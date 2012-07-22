insert_person = ->{}
update_person = ->{}
delete_person = ->{}
fetch_person = ->{}


empty_map = []

add = ->(map,key,value) {
  [key,value,map]
}
get = ->(map,key) {
  return nil if map == nil
  return map[1] if map[0] == key
  return get.(map[2],key)
}

include_namespace = ->(namespace,code) {
  code.(->(key) { get(namespace,key) })
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

people = add.(empty_map ,:insert ,insert_person)
people = add.(people    ,:update ,update_person)
people = add.(people    ,:delete ,delete_person)
people = add.(people    ,:fetch  ,fetch_person)
people = add.(people    ,:new    ,new_person)

add_person = ->(name,birthdate,gender) {
  return [nil,"Name is required"]                  if String(person.(:name)) == ''
  return [nil,"Birthdate is required"]             if String(person.(:birthdate)) == ''
  return [nil,"Gender is required"]                if String(person.(:gender)) == ''
  return [nil,"Gender must be 'male' or 'female'"] if person.(:gender) != 'male' &&
                                                      person.(:gender) != 'female'
  include_namespace(people, ->(_) {
    id = _(:insert).(person.(:name),
                     person.(:birthdate),
                     person.(:gender),
                     person.(:title)), [_(:new).(:with_id,id),nil]
  })
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

handle_result = ->(result,on_success,on_error) {
  if result[1] == nil
    on_success.(result[0])
  else
    on_error.(result[1])
  end
}

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


person = get_new_person.call
