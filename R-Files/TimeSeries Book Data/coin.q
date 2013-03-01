coinec.ml_function(data,rk,order){
	dn_length(data[,1])
	k_length(data[1,])
	dnum_dn-order
	dd_diff(data)
	coin_0
	coin$order_order
	if (order == 0)	{
		coin$residuals_t(data)
		coin$Zu_(coin$residuals)%*%t(coin$residuals)/dnum
		coin	
	}
	else {

	coin$dY_matrix(nr=k,nc=dnum)
	for (i in 1:k){
		coin$dY[i,]_dd[order:(dn-1),i]
	}
	coin$Y1_matrix(nr=k,nc=dnum)	
	for (i in 1:k){
		coin$Y1[i,]_data[order:(dn-1),i]
	}

	if (order > 1) {
		coin$dX_matrix(nr=k*(order-1),nc=dnum)
		for (i in 1:(order-1)){
			for (j in 1:k){
				coin$dX[(i-1)*k+j,]_dd[(order-i):(dn-i-1),j]
			}
		}
		coin$M_imat(dnum)-t(coin$dX)%*%solve(coin$dX%*%t(coin$dX))%*%coin$dX
	}
	else {
		coin$M_imat(dnum);
	}
	coin$R0_coin$dY%*%coin$M
	coin$R1_coin$Y1%*%coin$M
	coin$S00_coin$R0%*%t(coin$R0)/dnum
	coin$S10_coin$R1%*%t(coin$R0)/dnum
	coin$S01_coin$R0%*%t(coin$R1)/dnum
	coin$S11_coin$R1%*%t(coin$R1)/dnum
	coin$G_findG(coin$S11)
	
	coin$eigM_coin$G%*%coin$S10%*%solve(coin$S00)%*%coin$S01%*%t(coin$G)
	coin$eig_eigen(coin$eigM)
	coin$C_t(coin$eig$vectors[,1:rk])%*%coin$G
	coin$H_-coin$S01%*%t(coin$C)%*%solve(coin$C%*%coin$S11%*%t(coin$C))
	if (order > 1) {
		coin$D_(coin$dY+coin$H%*%coin$C%*%coin$Y1)%*%t(coin$dX)%*%solve(coin$dX%*%t(coin$dX))
		coin$residuals_coin$dY-coin$D%*%coin$dX+coin$H%*%coin$C%*%coin$Y1
	}
	else {
		coin$residuals_coin$dY+coin$H%*%coin$C%*%coin$Y1
	}
	coin$Zu_(coin$residuals)%*%t(coin$residuals)/dnum
        coin$Qr_numeric()
        coin$Qr_0
        for(i in (rk+1):k){
          coin$Qr_coin$Qr - (dn*log(1 - coin$eig$values[i]))
        }

	if(order>1) {
		J_matrix(0,nr=k,nc=k*order)
		J[1:k,1:k]_imat(k)
		W_-imat(k*order)
		for (i in 2:order) {
			W[((i-1)*k+1):(i*k),((i-2)*k+1):((i-1)*k)]_imat(k)
		}
		DP_matrix(nr=k,nc=k*order)
		DP[,(k+1):(order*k)]_coin$D
		DP[,1:k]_coin$H%*%coin$C	
		coin$ar_DP%*%W+J
	}
	else {
		coin$ar_imat(k)-coin$H%*%coin$C
	}

# calculate t-ratio of VaR(p) model
	coin$Y_matrix(nr=k*order,nc=dnum)
	for (i in 1:order) {
		coin$Y[((i-1)*k+1):(i*k),]_t(data[(order+1-i):(dn-i),])
	}
	beta_vec(coin$ar)
	Si_kronecker(solve(coin$Y%*%t(coin$Y)),coin$Zu)
	coin$tratio_matrix(nc=1,nr=k*k*order)
	for (i in 1:(k*k*order)) {
		coin$tratio[i,1]_beta[i]/(2*sqrt(Si[i,i]))
	}
	coin$tratio_vec.back(coin$tratio,k)
	coin
	
	}
}


findG_function(mat){
	k_length(mat[1,])
	G_matrix(0,nr=k,nc=k)
	for (i in 1:k) {
		invmat_solve(t(mat[1:i,1:i]))
		G[i,i]_sqrt(invmat[i,i])
		if (i>1) {
			for (j in 1:(i-1)){
				G[i,j]_invmat[j,i]/G[i,i]
			}
		}
	}
	G
}


coin.order_function(data,rk,order.max=15){
	k_length(data[1,])
	ord_0
	ord$order_c(0:order.max)
	ord$AIC_matrix(nc=1,nr=order.max+1)
	ord$HQ_matrix(nc=1,nr=order.max+1)
	ord$SC_matrix(nc=1,nr=order.max+1)
	for (i in 0:order.max){
		dnum_length(data[,1])-i
		coin_coinec.ml(data,rk,i)
		lnZ_log(det(coin$Zu))
		ord$AIC[i+1,1]_lnZ+2*i*k*k/dnum
		ord$HQ[i+1,1]_lnZ+2*log(log(dnum))*i*k*k/dnum
		ord$SC[i+1,1]_lnZ+log(dnum)*i*k*k/dnum
	}
	ord
}

coin.var1_function(model,data){
	n_model$order
	k_length(data[1,])

	if (n  < 2) {
		model
	}
	else {
		I.k_matrix(0, nr=k, nc=k)
		for (i in 1:k){
			I.k[i,i]_1
		}
		Zero.k_matrix(0, nr=k, nc=k)
	
		varconv_model
		varconv$F_matrix(0, nr=k*n,nc=k*n)
		varconv$F[1:k,1:(k*n)]_model$ar[1:k,1:(k*n)]
	
		for (i in 1:n){
			for (j in 2:n){
				if ((i+1)==j){
					varconv$F[((j-1)*k+1):(j*k),((i-1)*k+1):(i*k)]_I.k
				} else{
					varconv$F[((j-1)*k+1):(j*k),((i-1)*k+1):(i*k)]_Zero.k
				}
			}
		}
	}
	varconv$Z1_matrix(0, nr=k*n,nc=k*n) 
	varconv$Z1[1:k,1:k]_model$Zu

	varconv
}

coin.Zh_function(model,h){
	Zh_model$Z1	
	F1_model$F
	if(h<=0){
		x_"h must be positive or zero"
		return(x)
	} 
	if(h>=2){
		for (i in 1:(h-1)){   
			if(i>=2){
				F1_F1%*%model$F
			}   
			Zh_Zh+F1%*%model$Z1%*%t(F1)
		}
	}
	Zh	
}


vec_function(mat) {
	c_length(mat[1,])
	r_length(mat[,1])
	vec.mat_matrix(nc=1,nr=c*r)
	for(i in 1:c) {
		for (j in 1:r) {
			vec.mat[(i-1)*r+j,1]_mat[j,i]
		}
	}
	vec.mat
}

vec.back_function(mat,r) {
	n_length(mat)
	temp_matrix(nc=(n/r),nr=r)
	count_1
	for(i in 1:(n/r)){
		for(j in 1:r){
			temp[j,i]_mat[count]
			count_count+1
		}
	}
	temp
}

det_function(x){
	prod(eigen(x)$values)
}

imat_function(n){
	I.n_matrix(0, nr=n, nc=n)
	for (i in 1:n){
		I.n[i,i]_1
	}
	I.n
} 



