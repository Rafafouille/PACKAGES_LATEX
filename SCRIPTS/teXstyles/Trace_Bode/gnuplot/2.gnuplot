set table "gnuplot/2.table"; set format "%.5f"
set samples 50.0; set parametric; plot [t=0:6] [] [] log10(10**t),20*log10(abs(10/sqrt(1+(0.01*10**t)**2)))
