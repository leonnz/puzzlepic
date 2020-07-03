class ImagePieceConfig {
  // First index is the blank square, mapped to the moveable pieces allowed directions.
  static Map<int, Map<int, String>> draggableDirections = {
    1: {
      2: "left",
      3: "left",
      4: "left",
      5: "up",
      9: "up",
      13: "up",
    },
    2: {
      1: "right",
      3: "left",
      4: "left",
      6: "up",
      10: "up",
      14: "up",
    },
    3: {
      1: "right",
      2: "right",
      4: "left",
      7: "up",
      11: "up",
      15: "up",
    },
    4: {
      1: "right",
      2: "right",
      3: "right",
      8: "up",
      12: "up",
      16: "up",
    },
    5: {
      1: "down",
      6: "left",
      7: "left",
      8: "left",
      9: "up",
      13: "up",
    },
    6: {
      2: "down",
      5: "right",
      7: "left",
      8: "left",
      10: "up",
      14: "up",
    },
    7: {
      3: "down",
      5: "right",
      6: "right",
      8: "left",
      11: "up",
      15: "up",
    },
    8: {
      4: "down",
      5: "right",
      6: "right",
      7: "right",
      12: "up",
      16: "up",
    },
    9: {
      1: "down",
      5: "down",
      10: "left",
      11: "left",
      12: "left",
      13: "up",
    },
    10: {
      2: "down",
      6: "down",
      9: "right",
      11: "left",
      12: "left",
      14: "up",
    },
    11: {
      3: "down",
      7: "down",
      9: "right",
      10: "right",
      12: "left",
      15: "up",
    },
    12: {
      4: "down",
      8: "down",
      9: "right",
      10: "right",
      11: "right",
      16: "up",
    },
    13: {
      1: "down",
      5: "down",
      9: "down",
      14: "left",
      15: "left",
      16: "left",
    },
    14: {
      2: "down",
      6: "down",
      10: "down",
      13: "right",
      15: "left",
      16: "left",
    },
    15: {
      3: "down",
      7: "down",
      11: "down",
      13: "right",
      14: "right",
      16: "left",
    },
    16: {
      4: "down",
      8: "down",
      12: "down",
      13: "right",
      14: "right",
      15: "right",
    },
  };

  // First index is the blank square, mapped to the moveable pieces
  // and the adjacent pieces that need to move with it.
  static Map<int, Map<int, List<int>>> draggablePieces = {
    1: {
      3: [2],
      4: [3, 2],
      9: [5],
      13: [9, 5],
    },
    2: {
      4: [3],
      10: [6],
      14: [10, 6],
    },
    3: {
      1: [2],
      11: [7],
      15: [11, 7],
    },
    4: {
      1: [2, 3],
      2: [3],
      12: [8],
      16: [12, 8],
    },
    5: {
      7: [6],
      8: [7, 6],
      13: [9],
    },
    6: {
      8: [7],
      14: [10],
    },
    7: {
      5: [6],
      15: [11],
    },
    8: {
      5: [6, 7],
      6: [7],
      16: [12],
    },
    9: {
      1: [5],
      11: [10],
      12: [11, 10],
    },
    10: {
      2: [6],
      12: [11],
    },
    11: {
      3: [7],
      9: [10],
    },
    12: {
      4: [8],
      9: [10, 11],
      10: [11]
    },
    13: {
      1: [5, 9],
      5: [9],
      15: [14],
      16: [15, 14],
    },
    14: {
      2: [6, 10],
      6: [10],
      16: [15],
    },
    15: {
      3: [7, 11],
      7: [11],
      13: [14]
    },
    16: {
      4: [8, 12],
      8: [12],
      13: [14, 15],
      14: [15]
    },
  };
}
