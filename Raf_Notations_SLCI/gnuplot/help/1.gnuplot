set table "gnuplot/help/1.table"; set format "%.5f"
set samples 100; set parametric; plot [t=-1:2] log10(10**t),20*log10(abs(3.0/sqrt((1-(10**t/18.0)**2)**2+(2*0.4*(10**t/18.0))**2)))
