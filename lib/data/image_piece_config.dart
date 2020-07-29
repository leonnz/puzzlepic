class ImagePieceConfig {
  // First index is the blank square, mapped to the moveable pieces allowed directions.
  static Map<int, Map<int, String>> draggableDirections =
      <int, Map<int, String>>{
    1: <int, String>{
      2: 'left',
      3: 'left',
      4: 'left',
      5: 'up',
      9: 'up',
      13: 'up',
    },
    2: <int, String>{
      1: 'right',
      3: 'left',
      4: 'left',
      6: 'up',
      10: 'up',
      14: 'up',
    },
    3: <int, String>{
      1: 'right',
      2: 'right',
      4: 'left',
      7: 'up',
      11: 'up',
      15: 'up',
    },
    4: <int, String>{
      1: 'right',
      2: 'right',
      3: 'right',
      8: 'up',
      12: 'up',
      16: 'up',
    },
    5: <int, String>{
      1: 'down',
      6: 'left',
      7: 'left',
      8: 'left',
      9: 'up',
      13: 'up',
    },
    6: <int, String>{
      2: 'down',
      5: 'right',
      7: 'left',
      8: 'left',
      10: 'up',
      14: 'up',
    },
    7: <int, String>{
      3: 'down',
      5: 'right',
      6: 'right',
      8: 'left',
      11: 'up',
      15: 'up',
    },
    8: <int, String>{
      4: 'down',
      5: 'right',
      6: 'right',
      7: 'right',
      12: 'up',
      16: 'up',
    },
    9: <int, String>{
      1: 'down',
      5: 'down',
      10: 'left',
      11: 'left',
      12: 'left',
      13: 'up',
    },
    10: <int, String>{
      2: 'down',
      6: 'down',
      9: 'right',
      11: 'left',
      12: 'left',
      14: 'up',
    },
    11: <int, String>{
      3: 'down',
      7: 'down',
      9: 'right',
      10: 'right',
      12: 'left',
      15: 'up',
    },
    12: <int, String>{
      4: 'down',
      8: 'down',
      9: 'right',
      10: 'right',
      11: 'right',
      16: 'up',
    },
    13: <int, String>{
      1: 'down',
      5: 'down',
      9: 'down',
      14: 'left',
      15: 'left',
      16: 'left',
    },
    14: <int, String>{
      2: 'down',
      6: 'down',
      10: 'down',
      13: 'right',
      15: 'left',
      16: 'left',
    },
    15: <int, String>{
      3: 'down',
      7: 'down',
      11: 'down',
      13: 'right',
      14: 'right',
      16: 'left',
    },
    16: <int, String>{
      4: 'down',
      8: 'down',
      12: 'down',
      13: 'right',
      14: 'right',
      15: 'right',
    },
  };

  // First index is the blank square, mapped to the moveable pieces
  // and the adjacent pieces that need to move with it.
  static Map<int, Map<int, List<int>>> draggablePieces =
      <int, Map<int, List<int>>>{
    1: <int, List<int>>{
      3: <int>[2],
      4: <int>[3, 2],
      9: <int>[5],
      13: <int>[9, 5],
    },
    2: <int, List<int>>{
      4: <int>[3],
      10: <int>[6],
      14: <int>[10, 6],
    },
    3: <int, List<int>>{
      1: <int>[2],
      11: <int>[7],
      15: <int>[11, 7],
    },
    4: <int, List<int>>{
      1: <int>[2, 3],
      2: <int>[3],
      12: <int>[8],
      16: <int>[12, 8],
    },
    5: <int, List<int>>{
      7: <int>[6],
      8: <int>[7, 6],
      13: <int>[9],
    },
    6: <int, List<int>>{
      8: <int>[7],
      14: <int>[10],
    },
    7: <int, List<int>>{
      5: <int>[6],
      15: <int>[11],
    },
    8: <int, List<int>>{
      5: <int>[6, 7],
      6: <int>[7],
      16: <int>[12],
    },
    9: <int, List<int>>{
      1: <int>[5],
      11: <int>[10],
      12: <int>[11, 10],
    },
    10: <int, List<int>>{
      2: <int>[6],
      12: <int>[11],
    },
    11: <int, List<int>>{
      3: <int>[7],
      9: <int>[10],
    },
    12: <int, List<int>>{
      4: <int>[8],
      9: <int>[10, 11],
      10: <int>[11]
    },
    13: <int, List<int>>{
      1: <int>[5, 9],
      5: <int>[9],
      15: <int>[14],
      16: <int>[15, 14],
    },
    14: <int, List<int>>{
      2: <int>[6, 10],
      6: <int>[10],
      16: <int>[15],
    },
    15: <int, List<int>>{
      3: <int>[7, 11],
      7: <int>[11],
      13: <int>[14]
    },
    16: <int, List<int>>{
      4: <int>[8, 12],
      8: <int>[12],
      13: <int>[14, 15],
      14: <int>[15]
    },
  };
}
