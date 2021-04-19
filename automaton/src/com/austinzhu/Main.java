package com.austinzhu;

import java.util.ArrayList;
import java.util.List;

public class Main {

    public Dfa nfaToDfa(Nfa nfa) {
        var states = Util.powerSetOf(nfa.states);
        var acceptStates = new ArrayList<List<State>>();
        for (var s : states) {
            for (var t : nfa.acceptStates) {
                if (s.contains(t)) {
                    acceptStates.add(s);
                }
            }
        }
        var startState =

        return null;
    }

    public static void main(String[] args) {
    }
}
