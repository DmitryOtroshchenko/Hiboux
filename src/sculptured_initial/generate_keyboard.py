#!/usr/bin/env python
# encoding: utf-8

from __future__ import division, unicode_literals, print_function

import itertools
import numpy as np


def pos_to_openscad(pos):
    assert len(pos) == 2, 'Incorrect pos.'
    openscad_repr = ', '.join(str(coord) for coord in pos)
    openscad_repr = '[{}]'.format(openscad_repr)
    return openscad_repr


class KeyUnit(object):

    KEY_WIDTH = 18.4

    SINGLE = 19.0

    KEYCAP_TO_PLATE_OFFSET = 6.7

    def __init__(self, angle, pos, prev_key_or_height):
        assert -np.pi / 2 <= angle <= np.pi / 2, 'Incorrect angle.'
        self.angle = angle

        try:
            close_height = float(prev_key_or_height)
        except TypeError:
            prev_key = prev_key_or_height
            close_height = prev_key.far_height

        assert close_height > 0, 'Invalid key height.'
        self.close_height = close_height
        self.far_height = self.close_height - self.KEY_WIDTH * np.sin(self.angle)

        self.pos = np.asarray(pos)
        assert self.pos.shape == (2,), 'Incorrect coordinate format.'

        self.width = self.SINGLE
        self.depth = self.KEY_WIDTH * np.cos(self.angle)

    @property
    def keycap_offset(self):
        return self.KEYCAP_TO_PLATE_OFFSET / np.cos(self.angle)

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

    def to_openscad(self, what):
        assert what in {'key', 'support', 'hole'}, 'What?'
        openscad_repr = "ku_{what}({pos}, {angle}, {height});".format(
            what=what,
            pos=pos_to_openscad(self.pos),
            angle=self.angle / np.pi * 180,
            height=self.close_height
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
        prev_key = 40
        for a, ox, oz in itertools.izip(self.angles, self.offsets_x, self.offsets_z):
            new_key = KeyUnit(a, [xmax, 0], prev_key)
            self.keys.append(new_key)
            xmax = new_key.xmax
            prev_key = new_key

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


def main():
    angles = [np.pi / 4, np.pi / 12, 0, -np.pi / 12, -np.pi / 4]
    offsets_x = [0, 0, 0, 0, 0]
    offsets_z = [0, 0, 0, 0, 0]
    col = Column(angles, offsets_x, offsets_z)

    print()
    print(col.to_openscad())


if __name__ == '__main__':
    main()
