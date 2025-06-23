class Vector {
  int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) {
    return Vector(x + v.x, y + v.y);
  }

  @override
  String toString() {
    return "Vector(x: \$x, y: \$y)";
  }
}

void main() {
  Vector v1 = Vector(1, 2);
  Vector v2 = Vector(3, 4);
  Vector result = v1 + v2;
  print("Pritom Saha's \$result");
}
