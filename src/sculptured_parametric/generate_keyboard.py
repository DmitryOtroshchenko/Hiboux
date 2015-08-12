#!/usr/bin/env python
# encoding: utf-8

from __future__ import division, unicode_literals, print_function

import itertools
import numpy as np


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

    def __init__(self, angle, pos, close_height, width):
        assert -np.pi / 2 <= angle <= np.pi / 2, 'Incorrect angle.'
        self.angle = angle

        close_height = float(close_height)
        assert close_height > 0, 'Invalid key height.'
        self.close_height = close_height
        self.far_height = self.close_height - self.KEY_WIDTH * np.sin(self.angle)

        self.pos = np.asarray(pos)
        assert self.pos.shape == (3,), 'Incorrect coordinate format.'

        self.width = width
        self.depth = self.KEY_WIDTH * np.cos(self.angle)

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
        return self.xmin + self.depth

    @property
    def ymin(self):
        return self.pos[1]

    @property
    def ymax(self):
        return self.ymin + self.width

    def to_openscad(self, what):
        assert what in {'key', 'support', 'hole'}, 'What?'
        openscad_repr = "ku_{what}({pos}, {angle}, {height}, {width});".format(
            what=what,
            pos=pos_to_openscad(self.pos),
            angle=self.angle / np.pi * 180,
            height=self.close_height,
            width=self.width / self.SINGLE
        )
        return openscad_repr


class Column(object):

    def __init__(self, y, height, width, mask, angles, offsets_x, offsets_z):
        assert len(mask) == len(angles) == len(offsets_x) == len(offsets_z) == 5, \
            'Incorrect column parameters.'
        self.mask = mask
        self.angles = angles
        self.offsets_x = offsets_x
        self.offsets_z = offsets_z

        assert height >= 0, 'Incorrect column initial height.'
        assert width >= 0, 'Incorrect column width.'

        self.keys = []
        xmax = 0
        prev_key_height = height
        for is_present, a, ox, oz in itertools.izip(self.mask, self.angles, self.offsets_x, self.offsets_z):
            new_key = KeyUnit(a, [xmax + ox, y, oz], prev_key_height + oz, width)
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
            masks, angles, offsets_x, offsets_z,
            col_offsets_x, col_offsets_y, col_offsets_z, col_widths):

        self.masks = np.asarray(masks)
        self.angles = np.asarray(angles)
        self.offsets_x = np.asarray(offsets_x)
        self.offsets_z = np.asarray(offsets_z)

        assert self.masks.shape == self.angles.shape == self.offsets_x.shape == self.offsets_z.shape, \
            'Incorrect keyboard parameters.'

        self.col_offsets_x = np.asarray(col_offsets_x)
        self.col_offsets_y = np.asarray(col_offsets_y)
        self.col_offsets_z = np.asarray(col_offsets_z)
        self.col_widths = np.asarray(col_widths)
        assert len(self.col_offsets_x) == len(self.col_offsets_y) == len(self.col_offsets_z) == len(self.angles) == len(self.col_widths), \
            'Incorrect column offsets.'

        # TODO: refactor?
        self.offsets_x[:, 0] += self.col_offsets_x
        self.offsets_z[:, 0] += self.col_offsets_z

        self.columns = []
        ymax = 0
        for col_ix in xrange(len(self.angles)):
            ymax += col_offsets_y[col_ix]
            new_col = Column(
                ymax,
                height,
                self.col_widths[col_ix],
                self.masks[col_ix],
                self.angles[col_ix],
                self.offsets_x[col_ix],
                self.offsets_z[col_ix],
            )
            self.columns.append(new_col)
            ymax += self.col_widths[col_ix]

    def to_openscad(self):
        header = '''
include <../common.scad>;
include <../keycaps/dsa.scad>;
include <one_key_unit.scad>;

USE_SIMPLIFIED_KEYS = false;

'''
        columns_repr = '\n'.join(col.to_openscad() for col in self.columns)
        openscad_repr = ''.join([header, columns_repr])
        return openscad_repr


def main():
    a90 = np.pi / 2
    a60 = np.pi / 3
    a45 = a90 / 2
    a30 = a90 / 3
    a15 = a90 / 6
    a10 = a90 / 9
    a20 = a10 * 2

    masks = [
        [True, True, True, True, True],
        [True, True, True, True, True],
        [True, True, True, True, True],
        [False, True, True, True, True],
        [False, True, True, True, True],
        [False, True, True, True, True],
    ]
    angles = [
        [a30, a10, 0, -a20, -a60],
        [a30, a10, 0, -a20, -a60],
        [a30, a10, 0, -a10, -a45],
        [a30, a10, 0, -a10, -a45],
        [a30, a10, 0, -a10, -a45],
        [a30, a10, 0, -a10, -a45],
    ]
    offsets_x = [
        [0, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
    ]
    offsets_z = [
        [0, -1, -1, 1, 1],
        [0, -1, -1, 1, 1],
        [0, -1, -1, 1, 1],
        [0, -1, -1, 1, 1],
        [0, -1, -1, 1, 1],
        [0, -1, -1, 1, 1],
    ]
    col_offsets_x = [-10, -10, 0, 5, 0, 0]
    col_offsets_y = [0, 0, 0, 0, 0, 0]
    col_offsets_z = [0, 0, 0, 0, 0, 0]
    col_widths = [
        KeyUnit.SINGLE_AND_HALF, KeyUnit.SINGLE, KeyUnit.SINGLE,
        KeyUnit.SINGLE, KeyUnit.SINGLE, KeyUnit.SINGLE
    ]
    kbd = Keyboard(
        30,
        masks, angles, offsets_x, offsets_z,
        col_offsets_x, col_offsets_y, col_offsets_z, col_widths
    )
    print(kbd.to_openscad())


if __name__ == '__main__':
    main()
