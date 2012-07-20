square = ->(x) { x * x }
p square.(4) # => 16

person = ["Dave",:male, 2011]
print_person = ->((name,gender, year)) {
  puts "#{name} is a #{gender} is #{year}"
}
print_person.(person)
