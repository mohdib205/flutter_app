

abstract class Shape {
  double area();
  double perimeter();
}


class Square extends Shape {
  double side;

  Square(this.side);

  @override
  double area() {
    return side * side;
  }


  @override
  double perimeter() {
    return 4 * side;
  }
}



class Rectangle extends Shape {
  double length, width;
  Rectangle(this.length, this.width);

  @override
  double area() {
    return length * width;
  }

  @override
  double perimeter() {
    return 2 * (length + width);
  }
}


void main(){

  Shape rect1=Rectangle(10, 22);
  print(rect1.perimeter());


}





