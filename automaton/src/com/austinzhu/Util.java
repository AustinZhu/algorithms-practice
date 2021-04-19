package com.austinzhu;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

public class Util {

    public static <T> List<List<T>> powerSetOf(List<T> list) {
        T removed = list.get(0);
        list.remove(0);
        return Util.powerSetHelper(list, removed);
    }

    private static <T> List<List<T>> powerSetHelper(List<T> list, T removed) {
        if (list.isEmpty()) {
            List<List<T>> powerSet = new ArrayList<>();
            powerSet.add(list);
            powerSet.add(new ArrayList<>(List.of(removed)));
            return powerSet;
        }
        List<List<T>> power = powerSetOf(list);
        power.addAll(power.stream().map(l -> {
            var temp = new ArrayList<>(l);
            temp.add(removed);
            return temp;
        }).collect(Collectors.toList()));
        return power;
    }

    public static List<State> shortcuts(State state, BiFunction<State, String, List<State>> transFunc) {
        if (state == null) {
            return new ArrayList<>();
        }
        List<State> shortcutList = new ArrayList<>();
        shortcutList.add(state);
        shortcuts = transFunc.apply(state, "");
        for (var s : shortcuts) {
            shortcutList.addAll(shortcuts(s, transFunc));
        }
        return shortcutList;
    }
}
