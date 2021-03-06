#!/usr/bin/env python
# encoding: utf-8

from __future__ import division, unicode_literals, print_function

import itertools
import numpy as np


def allequal(*args):
    if not args:
        return True

    etalon = args[0]
    for a in args:
        if a != etalon:
            return False
    return True


def pos_to_openscad(pos):
    assert len(pos) == 3, 'Incorrect pos.'
    openscad_repr = ', '.join(str(coord) for coord in pos)
    openscad_repr = '[{}]'.format(openscad_repr)
    return openscad_repr


class KeyUnit(object):

    KEY_WIDTH = 18.4

    SINGLE = 19.0

    SINGLE_AND_HALF = SINGLE * 1.5

    DOUBLE = SINGLE * 2

    KEYCAP_TO_PLATE_OFFSET = 6.7

    def __init__(self, angle, pos, close_height, width, offset_before, offset_after):
        assert -np.pi / 2 <= angle <= np.pi / 2, 'Incorrect angle.'
        self.angle = angle

        assert offset_before >= 0, 'Incorrect offset_before.'
        self.offset_before = offset_before

        assert offset_after >= 0, 'Incorrect offset_after.'
        self.offset_after = offset_after


        self.pos = np.asarray(pos)
        assert self.pos.shape == (3,), 'Incorrect coordinate format.'

        self.width = width
        self.depth_to_forward_key_edge = self.offset_before + self.KEY_WIDTH * np.cos(self.angle)
        self.total_depth = self.depth_to_forward_key_edge + self.offset_after

        close_height = float(close_height)
        assert close_height > 0, 'Invalid key height.'
        self.close_height = close_height
        self.far_height = self.close_height - self.KEY_WIDTH * np.sin(self.angle)

    @property
    def max_height(self):
        return max(self.close_height, self.far_height)

    @property
    def min_height(self):
        return min(self.close_height, self.far_height)

    @property
    def xmin(self):
        return self.pos[0]

    @property
    def xmax(self):
        return self.xmin + self.total_depth

    @property
    def ymin(self):
        return self.pos[1]

    @property
    def ymax(self):
        return self.ymin + self.width

    def to_openscad(self, what):
        assert what in {'key', 'support', 'hole'}, 'What?'
        openscad_repr = "ku_{what}({pos}, {angle}, {height}, {width}, {offset_before}, {offset_after});".format(
            what=what,
            pos=pos_to_openscad(self.pos),
            angle=self.angle / np.pi * 180,
            height=self.close_height,
            width=self.width / self.SINGLE,
            offset_before=self.offset_before,
            offset_after=self.offset_after
        )
        return openscad_repr


class Column(object):

    def __init__(self, pos, height, width, mask, angles, offsets_x_before, offsets_x_after, offsets_z):
        key_params_lengths_equal = allequal(
            5, len(mask), len(angles),
            len(offsets_x_before), len(offsets_x_after),
            len(offsets_z)
        )
        assert key_params_lengths_equal, 'Incorrect column parameters.'

        assert len(pos) == 2, 'Incorrect column position.'

        self.mask = mask
        self.angles = angles
        self.offsets_x_before = offsets_x_before
        self.offsets_x_after = offsets_x_after
        self.offsets_z = offsets_z

        assert height >= 0, 'Incorrect column initial height.'
        assert width >= 0, 'Incorrect column width.'

        self.keys = []
        xmax = pos[0]
        prev_key_height = height

        key_params = itertools.izip(
            self.mask,
            self.angles,
            self.offsets_x_before,
            self.offsets_x_after,
            self.offsets_z
        )
        for is_present, a, oxb, oxa, oz in key_params:
            new_key = KeyUnit(
                a,
                [xmax, pos[1], oz],
                prev_key_height + oz,
                width,
                oxb,
                oxa
            )
            # TODO: not the most straightforward solution.
            if is_present:
                self.keys.append(new_key)

            xmax = new_key.xmax
            prev_key_height = new_key.far_height

    def to_openscad(self):
        openscad_repr = '''
difference() {{
    union() {{
        {supports}
    }}
    union() {{
        {holes}
    }}
}}
union() {{
    {keys}
}}
        '''.format(
            supports='\n'.join(k.to_openscad('support') for k in self.keys),
            keys='\n'.join(k.to_openscad('key') for k in self.keys),
            holes='\n'.join(k.to_openscad('hole') for k in self.keys),
        )
        return openscad_repr


class Keyboard(object):

    def __init__(self, height,
            masks, angles, offsets_x_before, offsets_x_after, offsets_z,
            col_offsets_x, col_offsets_y, col_offsets_z, col_widths):

        self.masks = np.asarray(masks)
        self.angles = np.asarray(angles)
        self.offsets_x_before = np.asarray(offsets_x_before)
        self.offsets_x_after = np.asarray(offsets_x_after)
        self.offsets_z = np.asarray(offsets_z)

        key_params_sahapes_equal = allequal(
            self.masks.shape, self.angles.shape,
            self.offsets_x_before.shape, self.offsets_x_after.shape,
            self.offsets_z.shape
        )
        assert key_params_sahapes_equal, 'Incorrect keyboard parameters.'

        self.col_offsets_x = np.asarray(col_offsets_x)
        self.col_offsets_y = np.asarray(col_offsets_y)
        self.col_offsets_z = np.asarray(col_offsets_z)
        self.col_widths = np.asarray(col_widths)

        col_params_lengths_equal = allequal(
            len(self.col_offsets_x), len(self.col_offsets_y),
            len(self.col_offsets_z), len(self.angles), len(self.col_widths)
        )
        assert col_params_lengths_equal, 'Incorrect column offsets.'

        # TODO: refactor?
        self.offsets_z[:, 0] += self.col_offsets_z

        self.columns = []
        ymax = 0
        for col_ix in xrange(len(self.angles)):
            ymax += col_offsets_y[col_ix]
            new_col = Column(
                [self.col_offsets_x[col_ix], ymax],
                height,
                self.col_widths[col_ix],
                self.masks[col_ix],
                self.angles[col_ix],
                self.offsets_x_before[col_ix],
                self.offsets_x_after[col_ix],
                self.offsets_z[col_ix],
            )
            self.columns.append(new_col)
            ymax += self.col_widths[col_ix]

    def to_openscad(self):
        header = '''
include <../common.scad>;
include <key_unit.scad>;

'''
        columns_repr = '\n'.join(col.to_openscad() for col in self.columns)
        openscad_repr = ''.join([header, columns_repr])
        return openscad_repr


def main():
    masks = [
        [True, True, True, True, True],
        [True, True, True, True, True],
        [True, True, True, True, True],
        [False, True, True, True, True],
        [False, True, True, True, True],
        [False, True, True, True, True],
    ]
    angles = np.array([
        [30, 10, 0, -20, -60],
        [30, 10, 0, -20, -60],
        [30, 10, 0, -10, -45],
        [30, 10, 0, -10, -45],
        [30, 10, 0, -10, -45],
        [30, 10, 0, -10, -45],
    ])
    angles = angles / 180 * np.pi
    offsets_x_before = [
        [4, 0, 0, 0, 0],
        [4, 0, 0, 0, 0],
        [4, 0, 0, 0, 0],
        [0, 5, 0, 0, 0],
        [0, 2, 0, 0, 0],
        [0, 2, 0, 0, 0],
    ]
    offsets_x_after = [
        [1, 1, 1, 1, 4],
        [1, 1, 1, 1, 4],
        [1, 1, 1, 1, 4],
        [1, 1, 1, 1, 4],
        [1, 1, 1, 1, 4],
        [1, 1, 1, 1, 4],
    ]
    offsets_z = [
        [0, 0, 0, 0, 0.5],
        [0, 0, 0, 0, 0.5],
        [0, 0, 0, 0, 0.5],
        [0, 0, 0, 0, 0.5],
        [0, 0, 0, 0, 0.5],
        [0, 0, 0, 0, 0.5],
    ]
    col_offsets_x = [-10, -10, 0, 3, 0, 0]
    col_offsets_y = [0, 0, 0, 0, 0, 0]
    col_offsets_z = [0, 0, 0, 0, 0, 0]
    col_widths = [
        KeyUnit.SINGLE_AND_HALF, KeyUnit.SINGLE, KeyUnit.SINGLE,
        KeyUnit.SINGLE, KeyUnit.SINGLE, KeyUnit.SINGLE
    ]
    kbd = Keyboard(
        30,
        masks, angles, offsets_x_before, offsets_x_after, offsets_z,
        col_offsets_x, col_offsets_y, col_offsets_z, col_widths
    )
    print(kbd.to_openscad())


if __name__ == '__main__':
    main()
