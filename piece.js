class Piece {
    type;
    shape;
    ctx;
    xPos = 0;
    yPos = 0;
    constructor(ctx, type) {
        this.type = type;
        this.shape = SHAPES[type];
        this.ctx = ctx;
    }

    changeCtx(ctx) {
        this.ctx = ctx;
    }

    setStartPosition() {
        this.xPos = 3
        this.yPos = -2;
    }

    setDisplayPosition() {
        this.xPos = 0;
        this.yPos = 0;
    }

    draw() {
        this.shape.forEach((row, j) => {
            row.forEach((cell, i) => {
                if (cell > 0) {
                    drawBlock(this.ctx, COLORS[cell - 1],
                        this.xPos + i,
                        this.yPos + j
                    );
                }
            });
        });
    }
}
