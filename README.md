# blue

## evaluate queries on any instance

```ruby
query = "a = \"blue\" and b = 5 or (c != 3 and d = [1,2,3])"
instance = OpenStruct.new(a: "blue", b: 5, c: 4, d: [1,2,3])
res = Blue::Evaluator.new(instance, query).eval # true
```
