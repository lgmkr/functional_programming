add_person = ->(name,birthdate,gender) {
  return [nil,"Name is required"]                  if String(person.(:name)) == ''
  return [nil,"Birthdate is required"]             if String(person.(:birthdate)) == ''
  return [nil,"Gender is required"]                if String(person.(:gender)) == ''
  return [nil,"Gender must be 'male' or 'female'"] if person.(:gender) != 'male' &&
                                                      person.(:gender) != 'female'

  id = insert_person.(person.(:name),person.(:birthdate),person.(:gender),person.(:title))
  [person.(:with_id, id),nil]
}

new_person = ->(name,birthdate,gender,title,id=nil) {
  return ->(attribute) {
    return id        if attribute == :id
    return name      if attribute == :name
    return birthdate if attribute == :birthdate
    return gender    if attribute == :gender
    return title     if attribute == :title
    if attribute == :salutation
      if String(title) == ''
        return name
      else
        return title + " " + name
      end
    elsif attribute == :update
      update_person.(name,birthdate,gender,title,id)
    elsif attribute == :destroy
      delete_person.(id)
    end
    if attribute == :with_id # <===
      return new_person.(name,birthdate,gender,title,args[0])
    end
    nil
  }
}

new_employee = ->(name,birthdate,gender,title,employee_id_number,id) {
  person = new_person.(name,birthdate,gender,title,id)
  return ->(attribute) {
    return employee_id_number if attribute == :employee_id_number
    return person.(attribute)
  }
}

read_person_from_user = -> {
  puts "Name?"
  name = gets.chomp
  puts "Birthdate?"
  birthdate = gets.chomp
  puts "Gender?"
  gender = gets.chomp
  puts "Title?"
  title = gets.chomp
  new_person.(name,birthdate,gender, title)
}

person_id = ->(*_,id) { id }

get_new_person = -> {
    handle_result.(add_person.(read_person_from_user.()),
    ->(person){
      puts "Successfully added person #{person.(:id)}"
      person
    },
    ->(error_message) {
      puts "Problem: #{error_message}"
      get_new_person.()
    }
  ) 
}

handle_result = ->(result,on_success,on_error) {
  if result[1] == nil
    on_success.(result[0])
  else
    on_error.(result[1])
  end
}

person = get_new_person.call
