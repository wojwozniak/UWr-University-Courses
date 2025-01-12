public class Trojkat {
    public Punkt punktA;
    public Punkt punktB;
    public Punkt punktC;

    public Trojkat(Punkt punktA, Punkt punktB, Punkt punktC) {
        if (punktA.equals(punktB) || punktA.equals(punktC) || punktB.equals(punktC)) {
            throw new IllegalArgumentException("Punkty trójkąta są takie same, nie można utworzyć trójkąta.");
        }

        // Sprawdzamy jeszcze wspoliniosc punktów
        // Wzór na współliniowość punktów: (1/2) | [x1(y2 – y3) + x2(y3 – y1) + x3[y1 –
        // y2]| = 0
        double a = punktA.x;
        double b = punktA.y;
        double c = punktB.x;
        double d = punktB.y;
        double e = punktC.x;
        double f = punktC.y;

        if (a * (d - f) + c * (f - b) + e * (b - d) == 0) {
            throw new IllegalArgumentException("Punkty trójkąta są współliniowe, nie można utworzyć trójkąta.");
        }

        this.punktA = punktA;
        this.punktB = punktB;
        this.punktC = punktC;
    }

    public void przesuń(Wektor v) {
        punktA = new Punkt(punktA.x + v.x, punktA.y + v.y);
        punktB = new Punkt(punktB.x + v.x, punktB.y + v.y);
        punktC = new Punkt(punktC.x + v.x, punktC.y + v.y);
    }

    public void obróć(Punkt p, double kąt) {
        punktA = obróćPunkt(punktA, p, kąt);
        punktB = obróćPunkt(punktB, p, kąt);
        punktC = obróćPunkt(punktC, p, kąt);
    }

    private Punkt obróćPunkt(Punkt p, Punkt obrót, double kąt) {
        // Ze wzorów na obrót punktu wokół innego punktu o zadany kąt
        // (https://pl.wikipedia.org/wiki/Obr%C3%B3t)
        double staryX = p.x;
        double staryY = p.y;
        double nowyX = obrót.x + (staryX - obrót.x) * Math.cos(kąt) - (staryY - obrót.y) * Math.sin(kąt);
        double nowyY = obrót.y + (staryX - obrót.x) * Math.sin(kąt) + (staryY - obrót.y) * Math.cos(kąt);
        return new Punkt(nowyX, nowyY);
    }

    public void odbij(Prosta p) {
        punktA = odbijPunkt(punktA, p);
        punktB = odbijPunkt(punktB, p);
        punktC = odbijPunkt(punktC, p);
    }

    private Punkt odbijPunkt(Punkt punkt, Prosta prosta) {
        double a = prosta.a;
        double b = prosta.b;
        double c = prosta.c;
        double x = punkt.x;
        double y = punkt.y;

        double a_prostopadla = -b;
        double b_prostopadla = a;

        double c_prostopadla = -(a_prostopadla * x) - (b_prostopadla * y);

        double x_przeciecia = (b * c_prostopadla - b_prostopadla * c) / (a * b_prostopadla - a_prostopadla * b);
        double y_przeciecia = (-a * c_prostopadla + a_prostopadla * c) / (a * b_prostopadla - a_prostopadla * b);

        double x_roznica = x_przeciecia - x;
        double y_roznica = y_przeciecia - y;

        return new Punkt(x_przeciecia + x_roznica, y_przeciecia + y_roznica);
    }
}
