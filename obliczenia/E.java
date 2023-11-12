package obliczenia;

public class E extends Stala {
    private final double wartosc = Math.E;
    private final String nazwa = "E";

    public E() {
        super(Math.E, "E");
    }

    @Override
    public double oblicz() {
        return wartosc;
    }

    @Override
    public String toString() {
        return nazwa;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
        }
        if (!(obj instanceof Stala)) {
            return false;
        }
        Stala other = (Stala) obj;
        return wartosc == other.wartosc;
    }
}
