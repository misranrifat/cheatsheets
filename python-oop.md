# Python OOP Cheatsheet

## Table of Contents
- [Classes and Objects](#classes-and-objects)
- [Special Methods](#special-methods)
- [Inheritance](#inheritance)
- [Encapsulation](#encapsulation)
- [Polymorphism](#polymorphism)
- [Abstract Classes](#abstract-classes)
- [Class and Static Methods](#class-and-static-methods)
- [Mixins](#mixins)
- [Descriptors](#descriptors)
- [Metaclasses](#metaclasses)
- [Data Classes](#data-classes-python-37)
- [Context Managers](#context-managers)
- [Type Hints](#type-hints-python-35)
- [Class Composition vs Inheritance](#class-composition-vs-inheritance)
- [Design Patterns Examples](#design-patterns-examples)
- [Advanced OOP Features](#advanced-oop-features)

## Classes and Objects

### Class Definition
```python
class ClassName:
    """Class docstring"""
    
    # Class variable (shared by all instances)
    class_variable = value
    
    def __init__(self, param1, param2):
        """Constructor method"""
        # Instance variables (unique to each instance)
        self.param1 = param1
        self.param2 = param2
        
    def method_name(self, args):
        """Method docstring"""
        # Method implementation
        return result
```

### Creating Objects
```python
# Create an instance of a class
my_object = ClassName(arg1, arg2)

# Access attributes
my_object.param1
my_object.class_variable

# Call methods
my_object.method_name(args)
```

## Special Methods

### Common Special Methods
```python
class MyClass:
    def __init__(self, value):
        self.value = value
    
    def __str__(self):
        """String representation for end-users"""
        return f"MyClass with value: {self.value}"
    
    def __repr__(self):
        """String representation for developers"""
        return f"MyClass({self.value!r})"
    
    def __len__(self):
        """Return length of object"""
        return len(self.value)
    
    def __eq__(self, other):
        """Equality comparison"""
        if not isinstance(other, MyClass):
            return NotImplemented
        return self.value == other.value
    
    def __lt__(self, other):
        """Less than comparison"""
        if not isinstance(other, MyClass):
            return NotImplemented
        return self.value < other.value
    
    def __getitem__(self, key):
        """Access item by index/key"""
        return self.value[key]
    
    def __setitem__(self, key, value):
        """Set item by index/key"""
        self.value[key] = value
    
    def __call__(self, *args, **kwargs):
        """Make instance callable"""
        return f"Called with {args} and {kwargs}"
```

## Inheritance

### Basic Inheritance
```python
class Parent:
    def __init__(self, parent_attr):
        self.parent_attr = parent_attr
    
    def parent_method(self):
        return "Parent method"

class Child(Parent):
    def __init__(self, parent_attr, child_attr):
        # Call parent constructor
        super().__init__(parent_attr)
        self.child_attr = child_attr
    
    def child_method(self):
        return "Child method"
```

### Multiple Inheritance
```python
class Base1:
    def method1(self):
        return "Base1 method"

class Base2:
    def method2(self):
        return "Base2 method"

class MultiDerived(Base1, Base2):
    def derived_method(self):
        return "Derived method"
```

### Method Resolution Order (MRO)
```python
# View the method resolution order
print(MultiDerived.__mro__)
```

## Encapsulation

### Private and Protected Attributes
```python
class MyClass:
    def __init__(self):
        self.public = "Public"       # Public attribute
        self._protected = "Protected" # Protected attribute (convention)
        self.__private = "Private"   # Private attribute (name mangling)
    
    def get_private(self):
        return self.__private
    
    def set_private(self, value):
        self.__private = value
```

### Property Decorators
```python
class Person:
    def __init__(self, name):
        self._name = name
    
    @property
    def name(self):
        """Getter method"""
        return self._name
    
    @name.setter
    def name(self, value):
        """Setter method"""
        if not isinstance(value, str):
            raise TypeError("Name must be a string")
        self._name = value
    
    @name.deleter
    def name(self):
        """Deleter method"""
        del self._name
```

## Polymorphism

### Method Overriding
```python
class Animal:
    def speak(self):
        return "Animal speaks"

class Dog(Animal):
    def speak(self):  # Override parent method
        return "Woof!"

class Cat(Animal):
    def speak(self):  # Override parent method
        return "Meow!"
```

### Duck Typing
```python
def make_it_speak(entity):
    # No type checking, just expects a speak method
    return entity.speak()

# These work as long as they have a speak() method
make_it_speak(Dog())
make_it_speak(Cat())
```

## Abstract Classes

### Using ABC Module
```python
from abc import ABC, abstractmethod

class AbstractBase(ABC):
    @abstractmethod
    def abstract_method(self):
        """This method must be implemented by subclasses"""
        pass
    
    @property
    @abstractmethod
    def abstract_property(self):
        """This property must be implemented by subclasses"""
        pass

class Concrete(AbstractBase):
    def abstract_method(self):
        return "Implemented abstract method"
    
    @property
    def abstract_property(self):
        return "Implemented abstract property"
```

## Class and Static Methods

```python
class MyClass:
    class_var = "I'm a class variable"
    
    def __init__(self, instance_var):
        self.instance_var = instance_var
    
    def instance_method(self):
        """Regular instance method - has access to self"""
        return f"Instance: {self.instance_var}, Class: {self.class_var}"
    
    @classmethod
    def class_method(cls):
        """Class method - has access to class but not instance"""
        return f"Class: {cls.class_var}"
    
    @staticmethod
    def static_method(arg):
        """Static method - no access to instance or class"""
        return f"Static with {arg}"
```

## Mixins

```python
class LoggerMixin:
    def log(self, message):
        print(f"[LOG] {message}")

class NetworkMixin:
    def send_data(self, data):
        print(f"Sending: {data}")

class NetworkClient(NetworkMixin, LoggerMixin):
    def process(self, data):
        self.log(f"Processing {data}")
        self.send_data(data)
```

## Descriptors

```python
class Validator:
    def __init__(self, name, validation_func):
        self.name = name
        self.validation_func = validation_func
    
    def __get__(self, instance, owner):
        if instance is None:
            return self
        return instance.__dict__.get(self.name)
    
    def __set__(self, instance, value):
        if not self.validation_func(value):
            raise ValueError(f"Invalid value for {self.name}")
        instance.__dict__[self.name] = value

# Usage
def is_positive(value):
    return value > 0

class Person:
    age = Validator('age', is_positive)
    
    def __init__(self, name, age):
        self.name = name
        self.age = age  # This will use the descriptor
```

## Metaclasses

```python
class Meta(type):
    def __new__(mcs, name, bases, attrs):
        # Add attribute to class
        attrs["added_by_meta"] = "This was added by the metaclass"
        return super().__new__(mcs, name, bases, attrs)

class MyClass(metaclass=Meta):
    pass

# Now MyClass has the attribute 'added_by_meta'
print(MyClass.added_by_meta)
```

## Data Classes (Python 3.7+)

```python
from dataclasses import dataclass, field

@dataclass
class Product:
    name: str
    price: float
    quantity: int = 0
    tags: list = field(default_factory=list)
    
    def total_cost(self):
        return self.price * self.quantity
```

## Context Managers

```python
class FileManager:
    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None
    
    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.file:
            self.file.close()
        # Return True to suppress exceptions
        return False

# Usage
with FileManager('file.txt', 'w') as f:
    f.write('Hello, world!')
```

## Type Hints (Python 3.5+)

```python
from typing import List, Dict, Tuple, Optional, Union, Any, Callable

class TypedClass:
    def __init__(self, name: str, age: int) -> None:
        self.name: str = name
        self.age: int = age
    
    def greet(self) -> str:
        return f"Hello, {self.name}"
    
    def process_list(self, items: List[int]) -> List[int]:
        return [item * 2 for item in items]
    
    def process_dict(self, data: Dict[str, Any]) -> None:
        for key, value in data.items():
            print(f"{key}: {value}")
    
    def maybe_none(self) -> Optional[str]:
        if self.age > 18:
            return "Adult"
        return None
```

## Class Composition vs Inheritance

### Inheritance Example
```python
class Vehicle:
    def __init__(self, make, model):
        self.make = make
        self.model = model
    
    def move(self):
        return "Moving vehicle"

class Car(Vehicle):
    def __init__(self, make, model, year):
        super().__init__(make, model)
        self.year = year
    
    def move(self):
        return "Driving car"
```

### Composition Example
```python
class Engine:
    def start(self):
        return "Engine started"
    
    def stop(self):
        return "Engine stopped"

class Wheels:
    def rotate(self):
        return "Wheels rotating"

class Car:
    def __init__(self, make, model):
        self.make = make
        self.model = model
        self.engine = Engine()
        self.wheels = Wheels()
    
    def drive(self):
        return f"{self.engine.start()}, {self.wheels.rotate()}"
```

## Design Patterns Examples

### Singleton Pattern
```python
class Singleton:
    _instance = None
    
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
    
    def __init__(self, name="Default"):
        # Will only be executed once
        if not hasattr(self, 'initialized'):
            self.name = name
            self.initialized = True
```

### Factory Pattern
```python
class Animal:
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

class AnimalFactory:
    @staticmethod
    def create_animal(animal_type):
        if animal_type == "dog":
            return Dog()
        elif animal_type == "cat":
            return Cat()
        else:
            raise ValueError(f"Unknown animal type: {animal_type}")
```

### Observer Pattern
```python
class Subject:
    def __init__(self):
        self._observers = []
    
    def attach(self, observer):
        if observer not in self._observers:
            self._observers.append(observer)
    
    def detach(self, observer):
        try:
            self._observers.remove(observer)
        except ValueError:
            pass
    
    def notify(self, *args, **kwargs):
        for observer in self._observers:
            observer.update(self, *args, **kwargs)

class Observer:
    def update(self, subject, *args, **kwargs):
        pass
```

## Advanced OOP Features

### Slots
```python
class Person:
    __slots__ = ('name', 'age')  # Restricts attributes to these only
    
    def __init__(self, name, age):
        self.name = name
        self.age = age
```

### Custom Containers
```python
class MyList:
    def __init__(self):
        self.data = []
    
    def __getitem__(self, index):
        return self.data[index]
    
    def __setitem__(self, index, value):
        self.data[index] = value
    
    def __delitem__(self, index):
        del self.data[index]
    
    def __len__(self):
        return len(self.data)
    
    def append(self, item):
        self.data.append(item)
    
    def __iter__(self):
        return iter(self.data)
```

### Customizing Attribute Access
```python
class AttributeManager:
    def __getattr__(self, name):
        """Called when attribute doesn't exist"""
        return f"Attribute {name} not found"
    
    def __getattribute__(self, name):
        """Called for every attribute access"""
        print(f"Accessing {name}")
        return super().__getattribute__(name)
    
    def __setattr__(self, name, value):
        """Called when setting attributes"""
        print(f"Setting {name} to {value}")
        super().__setattr__(name, value)
    
    def __delattr__(self, name):
        """Called when deleting attributes"""
        print(f"Deleting {name}")
        super().__delattr__(name)
```

### Pickling Objects
```python
import pickle

class Picklable:
    def __init__(self, value):
        self.value = value
    
    def __getstate__(self):
        """Custom state for pickling"""
        return {'custom_state': self.value * 2}
    
    def __setstate__(self, state):
        """Custom unpickling behavior"""
        self.value = state['custom_state'] // 2
```