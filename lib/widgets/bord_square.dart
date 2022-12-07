class BoardSquare {
  bool hasBomb;
  int bombsAround;
  bool isRevealed;

  BoardSquare(
      {this.hasBomb = false, this.bombsAround = 0, this.isRevealed = false});
}
