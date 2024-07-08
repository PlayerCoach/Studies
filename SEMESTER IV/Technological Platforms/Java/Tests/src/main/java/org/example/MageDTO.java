package org.example;

public record MageDTO (
    String name,

    int level
) {
    @Override
    public String toString() {
        return "{name='"+ name + "', level=" + level + "}";
    }
}





