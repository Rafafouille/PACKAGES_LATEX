set table "gnuplot/help/3.table"; set format "%.5f"
set samples 100; set parametric; plot [t=-1:4] log10(10**t),180/3.1415957*(atan((18.0**2-(10**t)**2)/(2*0.4*18.0*10**t))-3.1415957/2)
