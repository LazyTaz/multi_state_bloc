# multi_state_bloc 0.0.3

**multi_state_bloc** is a straightforward solution allowing you to manage substates easily instead of creating one bloc for each state. It is only an abstract class that extends [bloc](https://github.com/felangel/bloc).


## Why & How ?

Each time you emit a state, the view is notified and the state is stored in the bloc and you can easily retrieve the last emitted state by looking at the *state* property of the bloc.

State classes will grow over time and become more and more complex (constructor, copyWith, props ...) and you could split the state class into several sub-state classes. But flutter_block can manage one state at a time. 

So if state A is issued, then state B, the overall state of the Bloc will be B and there is no way to retrieve A except by reinstantiating it or ***keeping it in memory***. 

This is what **multi_state_bloc** does ! It keeps in memory a reference to the states and it allows you to easily retrieve these states. In addition, as soon as a state is emitted, it is intercepted and automatically updated internally. So you don't have to worry about anything.


## Usage 

Inherit your bloc from `MultiStateBloc`. This the class responsible for keeping your states in memory.

```dart
    class Event {} 
    class BaseState {}
    
    class ConcreteStateA extends BaseState {}
    class ConcreteStateB extends BaseState {}
    
    class TestBloc extends MultiStateBloc<Event, BaseState> { 
        TestBloc(super.initialState);
    }
```


Then register the *events* and *states* the bloc will have to use during his lifetime.

```dart
    class TestBloc extends MultiStateBloc<Event, BaseState> { 
        TestBloc(super.initialState) {
            on<Event>(handleTest);
            
            holdState(() => ConcreteStateA());
            holdState(() => ConcreteStateB());
        }
    }
```

> [!WARNING]
> All states registered by holdState() should inherit from the same base class.


## Retrieving state inside your bloc

```dart
    FutureOr<void> handleTest(event, emit) async {
        var stateA = states<ConcreteStateA>();
        
        emit(stateA.copyWith(...));
    }
```

## Retrieving state inside your view

```dart
    BlocBuilder<TestBloc, BaseState>(
        builder: (context, state) {
            final bloc = context.read<TestBloc>();
            final stateA = bloc.states<ConcreteStateA>();
            
            [...]
        }
    )
```

## Filtering build requests

```dart
    BlocBuilder<TestBloc, BaseState>(
        buildWhen: (prev, next) => next is ConcreteStateA,
        builder: (context, state) {
            var stateA = state as ConcreteStateA;
            
            [...]
        }
    )
```
