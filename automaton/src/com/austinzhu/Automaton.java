package com.austinzhu;

import java.util.List;
import java.util.ListIterator;
import java.util.function.BiFunction;

class State {

    String name;

    Boolean isStart;

    Boolean isAccept;

    public State(String name, Boolean isStart, Boolean isAccept) {
        this.name = name;
        this.isStart = isStart;
        this.isAccept = isAccept;
    }
}

class Expression {

    class TokenExpr extends Expression {

        String literal;
    }

    class ConcatExpr extends Expression {

        Expression lexpr;

        Expression rexpr;
    }

    class StarExpr extends Expression {

        Expression expr;
    }

    class UnionExpr extends Expression {

        Expression lexpr;

        Expression rexpr;
    }
}

public abstract class Automaton<S, A, T> {

    protected List<State> states;

    protected List<String> alphabet;

    protected BiFunction<S, A, T> transFunc;

    protected State startState;

    protected List<State> acceptStates;

    Automaton(List<State> states, List<String> alphabet, BiFunction<S, A, T> transFunc, State startState, List<State> acceptStates) {
        this.states = states;
        this.alphabet = alphabet;
        this.transFunc = transFunc;
        this.startState = startState;
        this.acceptStates = acceptStates;
    }

    public abstract Boolean accept(List<String> string);

    public Boolean recognize(List<List<String>> strings) {
        return strings.stream()
                .map(this::accept)
                .reduce(true, (x, acc) -> x && acc);
    }
}

class Dfa extends Automaton<State, String, State> {

    Dfa(List<State> states, List<String> alphabet, BiFunction<State, String, State> transFunc, State startState, List<State> acceptStates) {
        super(states, alphabet, transFunc, startState, acceptStates);
    }

    @Override
    public Boolean accept(List<String> string) {
        State currentState = this.startState;
        for (String s : string) {
            currentState = this.transFunc.apply(currentState, s);
        }
        return currentState.isAccept;
    }
}

class Nfa extends Automaton<State, String, List<State>> {

    Nfa(List<State> states, List<String> alphabet, BiFunction<State, String, List<State>> transFunc, State startState, List<State> acceptStates) {
        super(states, alphabet, transFunc, startState, acceptStates);
    }

    @Override
    public Boolean accept(List<String> string) {
        return acceptHelper(this.startState, string.listIterator());
    }

    private Boolean acceptHelper(State currentState, ListIterator<String> string) {
        if (!string.hasNext()) {
            return currentState.isAccept;
        }
        return this.transFunc.apply(currentState, string.next()).stream()
                .map(q -> acceptHelper(q, string))
                .reduce(false, (x, acc) -> x || acc);
    }
}

class Gnfa extends Automaton<State, State, Expression> {

    Gnfa(List<State> states, List<String> alphabet, BiFunction<State, State, Expression> transFunc, State startState, List<State> acceptStates) {
        super(states, alphabet, transFunc, startState, acceptStates);
    }

    @Override
    public Boolean accept(List<String> string) {
        return null;
    }
}