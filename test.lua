local classic = require('classic')
local class = classic.class
local match = classic.match

local function dbg(t)
  for key, value in pairs(t) do
    print(string.format('%s: %s', key, value))
  end
end

---@class Person: classic.Class
---@field new fun(name?: string, age?: integer): self
local Person = {}
class(Person, function(C)
  Person.name = "Guest"
  Person.age = 0

  C.public()
  function Person:__init(name, age)
    if name ~= nil then
      self.name = name
    end

    if age ~= nil then
      self.age = age
    end

    Person._print_info()
    Person.population = Person.population + 1
  end

  function Person:say(text)
    print(string.format(
      '%s say: %s',
      self.name,
      text
    ))
  end

  function Person:get_info()
    return string.format('Name: %s\nAge: %d', self.name, self.age)
  end

  C.static()
  Person.population = 0

  C.private()
  ---@private
  function Person._print_info()
    print('new Person has been initialized')
  end
end)

---@class Strudent: Person
---@field new fun(name?: string, age?: integer, class?: string): self
local Student = {}
class(Student, Person, function(C)
  Student.class = nil

  C.public()
  function Student:say(text)
    print(string.format(
      'Student %s say: %s',
      self.name,
      text
    ))
  end

  function Student:get_info()
    return Person.get_info(self) .. '\nClass: ' .. (self.class or '???')
  end

  function Student:__init(name, age, class)
    Person.__init(self, name, age)
    if class ~= nil then
      self.class = class
    end
    Student.population = Student.population + 1
  end
end)

local p1 = Person.new('Rizwan Elansyah', 16)
p1:say('Hello World!')
print(p1:get_info())
Person.say(p1, 'Hello World Again!')
print('Population: ' .. Person.population)

local p2 = Person.new()
print('Population: ' .. Person.population)

local s1 = Student.new('Tom', 12, 'C')
s1:say('Hello I\'m a Student')
Person.say(s1, 'Hi')
print('Population: ' .. Person.population)
print('Student Population: ' .. Student.population)
print(s1:get_info())

local Dummy = {}
class(Dummy)


print(match(Person, Person))
print(match(Student, Person))
print(match(Person, Student))
print(match(Person, Dummy))
