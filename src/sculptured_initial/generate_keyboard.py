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

    KEYCAP_TO_PLATE_OFFSET = 6.7

    def __init__(self, angle, pos, close_height):
        assert -np.pi / 2 <= angle <= np.pi / 2, 'Incorrect angle.'
        self.angle = angle

        assert(close_height > 0);
        # TODO:
        self.close_height = close_height
        self.far_height = self.close_height - self.SINGLE * np.tan(self.angle)

        self.pos = np.asarray(pos)
        assert self.pos.shape == (3,), 'Incorrect coordinate format.'

        self.width = self.SINGLE
        self.depth = self.KEY_WIDTH * np.cos(abs(self.angle)) + self.KEYCAP_TO_PLATE_OFFSET * np.sin(abs(self.angle))

    @property
    def far_keycap_height(self):
        return self.far_height + self.KEYCAP_TO_PLATE_OFFSET / np.cos(self.angle)

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
        return self.pos[0] + self.depth

    @property
    def ymin(self):
        return self.pos[1]

    @property
    def ymax(self):
        return self.pos[1] + self.width

    def to_openscad(self):
        openscad_repr = "key_unit({pos}, {angle}, {height});".format(
            pos=pos_to_openscad(self.pos),
            angle=self.angle / np.pi * 180,
            height=self.max_height
        )
        return openscad_repr


class Column(object):

    def __init__(self, angles, offsets_x, offsets_z):
        assert len(angles) == len(offsets_x) == len(offsets_z) == 5, \
            'Incorrect column parameters.'
        self.angles = angles
        self.offsets_x = offsets_x
        self.offsets_z = offsets_z

        self.keys = []
        xmax = 0
        current_height = 40
        for a, ox, oz in itertools.izip(self.angles, self.offsets_x, self.offsets_z):
            print(current_height)
            new_key = KeyUnit(a, [xmax, 0, 0], current_height)
            self.keys.append(new_key)
            xmax = new_key.xmax
            current_height = new_key.far_keycap_height - 6.7

    def to_openscad(self):
        openscad_repr = '\n'.join(k.to_openscad() for k in self.keys)
        return openscad_repr


def main():
    angles = [np.pi / 4, np.pi / 12, 0, -np.pi / 12, -np.pi / 4]
    offsets_x = [0, 0, 0, 0, 0]
    offsets_z = [0, 0, 0, 0, 0]
    col = Column(angles, offsets_x, offsets_z)

    print()
    print(col.to_openscad())


if __name__ == '__main__':
    main()
