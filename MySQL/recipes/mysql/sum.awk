BEGIN { n = sum = 0 }
{ ++n; sum += $1 }
END { printf "n = %d, sum = %f\n", n, sum }
