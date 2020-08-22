class Piece {
    shape;
    ctx;
    xPos = 0;
    yPos = 0;
    constructor(ctx, shape) {
        this.shape = SHAPES[shape];
        this.ctx = ctx;
    }

    changeCtx(ctx) {
        this.ctx = ctx;
    }

    adjust() {
        this.xPos = 3;
        this.yPos = -2;
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
