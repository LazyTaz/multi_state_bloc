# multi_state_bloc 0.0.3

multi_state_bloc is a simple, but really powerful solution that allows you to use states of different type in one Bloc, instead of creating one Bloc for each state. It is an abstract class that extends Bloc (from **flutter_bloc**).


# Why & How ?


Each time you emit a state, the view is notified and the state is stored in the Bloc. 
What it means is that you can easily retrieve the last emitted state by looking at the *state* property of the Bloc.

State classes can get really big, as well as all the methods they contain (constructor, copyWith, props ...).
Sometimes we want to split our state into several sub-states, but this can be complicated because flutter_block only allows us to manage one state at a time. 

So if state A is issued, then state B, the overall state of the Bloc will be B and there is no way to get back to A except by reinstantiating it or ***keeping it in memory***. 

This is what multi_state_bloc does ! It keeps in memory a reference to the states and it allows you to easily retrieve these states. In addition, as soon as a state is emitted, it is intercepted and automatically updated internally. So you don't have to worry about anything.


## Usage 

Inherit your Bloc from `MultiStateBloc`. This the class responsible for keeping trace of your states.

    class Event {} 
    class BaseState {}
    
    class ConcreteStateA extends BaseState {}
    class ConcreteStateB extends BaseState {}
    
    class TestBloc extends MultiStateBloc<Event, BaseState> { 
        TestBloc(super.initialState);
    }

Then register the *events* and *states* the Bloc will have to use during his lifetime.

    class TestBloc extends MultiStateBloc<Event, BaseState> { 
        TestBloc(super.initialState) {
            on<Event>(handleTest);
            
            holdState(() => ConcreteStateA());
            holdState(() => ConcreteStateB());
        }
    }

You can now retrieve the states from anywhere in your Bloc and in your View (as soon as you get bloc's reference) !

    FutureOr<void> handleTest(event, emit) async {
        var stateA = states<ConcreteStateA>();
        
        emit(stateA.copyWith(...));
    }
### In the view :


    BlocBuilder<TestBloc, BaseState>
        builder: (context, state) {
            var bloc = context.read<TestBloc>();
            var stateA = bloc.states<ConcreteStateA>();
            
            [...]
        }

you can also filter build requests as you would have done for a single state.

    BlocBuilder<TestBloc, BaseState>
        buildWhen: (prev, next) => next is ConcreteStateA,
        builder: (context, state) {
            var stateA = state as ConcreteStateA;
            
            [...]
        }


## Limitations

* In order to be used in one Bloc, the states you registered should inherit from the same base class.



