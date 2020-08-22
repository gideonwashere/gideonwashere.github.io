// Get canvas contexts
var ctxBoard = document.getElementById('board').getContext('2d');
var ctxNext = document.getElementById('next').getContext('2d');
var ctxHeld = document.getElementById('held').getContext('2d');

let b, time;
init();

function play() {
    time = { start: 0, elapsed: 0, level: 1000 };
    b = new Board(ctxBoard, ctxNext, ctxHeld);
    addEventListener();
    requestAnimationFrame(animate);
}

function animate(now = 0) {
    time.elapsed = now - time.start;
    if (time.elapsed > time.level) {
        time.start = now;

        if(!b.paused)
            b.drop();
    }

    // Clear board before drawing new state.
    ctxBoard.clearRect(0, 0, ctxBoard.canvas.width, ctxBoard.canvas.height);
    ctxNext.clearRect(0, 0, ctxNext.canvas.width, ctxNext.canvas.height);
    ctxHeld.clearRect(0, 0, ctxHeld.canvas.width, ctxHeld.canvas.height);

    document.getElementById('lines').innerHTML = b.lines;

    b.draw();

    requestId = requestAnimationFrame(animate);
}

function addEventListener() {
    document.addEventListener('keydown', event => {
        event.preventDefault();

        if(!b.paused) {
        switch (event.keyCode) {
            case KEY.LEFT:
                b.left();
                break;
            case KEY.RIGHT:
                b.right();
                break;
            case KEY.DOWN:
                b.drop();
                break;
            case KEY.UP:
                b.rotate();
                break;
        }
    }
    });
}

function init() {
    // set board sizes
    this.ctxBoard.canvas.width = COLS * BLOCK_SIZE;
    this.ctxBoard.canvas.height = ROWS * BLOCK_SIZE;
    this.ctxNext.canvas.width = 4 * BLOCK_SIZE;
    this.ctxNext.canvas.height = 4 * BLOCK_SIZE;
    this.ctxHeld.canvas.width = 4 * BLOCK_SIZE;
    this.ctxHeld.canvas.height = 4 * BLOCK_SIZE;
}