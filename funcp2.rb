add_reson = lambda { |name,birthdate,gender| 
  return [nil,"Name is required"]                  if String(name) == ''
  return [nil,"Birthdate is required"]             if String(birthdate) == ''
  return [nil,"Gender is required"]                if String(gender) == ''
  return [nil,"Gender must be 'male' or 'female'"] if gender != 'male' && gender != 'female'

  id = insert_person.(name,birthdate,gender)
  [[name,birthdate,gender,id],nil]
}

invalid = true
while invalid
  puts "Name?"
  name = gets
  puts "Birthdate?"
  birthdate = gets
  puts "Gender?"
  gender = gets
  result = add_person.(name,birthdate,gender)
  if result[1] == nil
    puts "Successfully added person #{result[0][0]}"
    invalid = false
  else
    puts "Problem: #{result[1]}"
  end
end
