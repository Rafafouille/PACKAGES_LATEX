set table "gnuplot/1.table"; set format "%.5f"
set samples 1000.0; set parametric; plot [t=0:6] [] [] log10(10**t),(t<log10(1/(0.01))?20*log10(10):+20*log10(10/(0.01))-20*log10(10**t))
