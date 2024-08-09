# Basic OOP For Lua
A library that provide an OOP functionalities

## Usage
### - Creating class and instance
You can create a class by using the `class` function from module `classic.class`
this function didn't return any value instead modify the passed table to make the new class,
the passed table must be empty if not unexpected behaviour will happen.

```lua
local class = require('classic.class')

local Person = {}
class(Person)

local p = Person.new()
```

### - Fields
You can create a field by setting field on the passed table at constructor function,
the assisgned value will be the default value of that field,
but all defined field is private by default so you cannot access them outside of
the class or method.

```lua
local Person = {}
class(Person, function()
    -- define a field name with no default value
    Person.name = nil
    -- define a field age with 1 as default value
    Person.age = 1
end)

local p = Person.new()
print(p.age) --> ERROR: because the field is private
```

### - Visibility
You can set is the field or method attached to class (static) or object (field),
is the field or method is private or public. You can set it with calling the function
from the first parameter of the callback.

```lua
local Person = {}
class(Person, function(C)
    C.public()
    Person.name = nil -- this field is public
    Person.age = 1 -- this is public to

    C.private()
    Person.foo = 'bar' -- this field is private

    C.static().public()
    Person.population = 0 -- a public static field

    C.field().private()
    Person.secret = nil -- this field is private and not static
end)

local p = Person.new()
print(p.name) --> nil
print(p.age) --> 1
p.name = 'John'
print(p.name) --> 'John'
print(p.population) --> ERROR
print(Person.population) --> 0
print(Person.age) --> ERROR
print(p.secret) --> ERROR
```

### - Method
```lua
local Person = {}
class(Person, function(C)
    Person.name = nil
    Person.age = 1

    C.public()
    Person.say = function(self, msg)
        print(string.format('%s say: %s', self.name, tostring(msg)))
    end
    -- or
    function Person:hello_world()
        self:say('Hello World!')
    end
end)

local p = Person.new()
p:say('Hi')
p:hello_world()
-- or
Person.say(p. 'Hi')
Person.hello_world(p)
```

### - `__init` Method
`__init` method is called when the new instance is created,
when assigning this field, field will be automaticly public and not static

```lua
local Person = {}
class(Person, function(C)
    Person.name = ''
    Person.age = 1

    -- set to public automaticly
    function Person:__init(name, age)
        if name ~= nil then self.name = name end
        if age ~= nil then self.age = age end
    end

    C.public()
    function Person:get_info()
        return string.format('Name: %s\nAge: %d', self.name, self.age)
    end
end)

local p = Person.new('John', 28)
print(p:get_info()) --> 'Name: John
                    --> Age: 28'
```

### - Inheritance
```lua
local Person = {}
class(Person, function(C)
    Person.name = ''
    Person.age = 1

    C.public()
    Person.say = function(self, msg)
        print(string.format('%s say: %s', self.name, tostring(msg)))
    end

    function Person:__init(name, age)
        if name ~= nil then self.name = name end
        if age ~= nil then self.age = age end
    end

    function Person:get_info()
        return string.format('Name: %s\nAge: %d', self.name, self.age)
    end
end)

local Student = {}
class(Student, Person, function(C)
    Student.class = 'A'

    function Student:__init(name, age, class)
        Person.__init(self, name, age)
        if class ~= nil then self.class = class end
    end

    V.public()
    function Student:get_info()
        return Person.get_info(self) .. '\nClass: ' .. self.class
    end
end)

local s = Student.new('Tom', 12, 'B')

print(s:get_info()) --> 'Name: Tom
                    --> Age: 12
                    --> Class: B'

print(Person.get_info(s)) --> 'Name: Tom
                          --> Age: 12'

s:say('Hello') --> 'Tom say: Hello'
```
