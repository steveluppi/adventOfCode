import java.io.File

val lines = File("silver.txt").readLines().reversed()


var grandTotal = 0L

var op = ""
var nums: MutableList<Long> = mutableListOf()
for(c in lines.first().indices) {
  var num=""
  for(r in lines.indices){
    if(r == 0){
      if(lines.get(r).get(c)!=' '){
        op = lines.get(r).get(c).toString()
      }
    } else{
      num+=lines.get(r).get(c)
    }
  }
  num=num.reversed().trim()
  if(num==""){
    if(op == "+") {
      grandTotal += nums.sum()
    } else if (op == "*"){
      grandTotal += nums.reduce{acc, v -> acc * v}
    } else{
      println("OH NO $op")
    }
    nums.clear()
    op=""
  } else {
    nums.add(num.toLong())
  }
}
// capture the last column
if(op == "+") {
  grandTotal += nums.sum()
} else if (op == "*"){
  grandTotal += nums.reduce{acc, v -> acc * v}
} else{
  println("OH NO $op")
}

println("with a grand total of $grandTotal")
