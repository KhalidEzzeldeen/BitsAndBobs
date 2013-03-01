c***************************************************************************
c MAIN PROGRAM, CALLS THE SUBROUTINES UMINF AND FUNC
c***************************************************************************
      program kalman
      integer nobs, nparam
      parameter (nobs=67,nparam=4)
c     
      integer iparam(7)
      real func,fscale,fvalue,rparam(7),param(nparam),xguess(nparam),
&          xscale(nparam),ydata(8,67),r(8,8),covv(8,8)
      common ydata,r,covv
      external func,uminf,hfun,wfun,rfun

c**************************************************************************
c IMPORT THE DATA AS WELL AS THEIR SAMPLE VARIANCE COVARIANCE MATRIX
c**************************************************************************     
      open(5,file='zeros.dat')
      read(5,*) ((ydata(i,j),j=1,67),i=1,8)

      open(50,file='varcovar')
      read(50,*) ((r(i,j),j=1,8),i=1,8)
c**************************************************************************
c STARTING VALUES FOR THE LIKEHOOD MAXIMIZATION AS WELL AS 
c PARAMETERS NEEDED IN    UMINF
c**************************************************************************
      data xguess/7.0,70.0,15.0,2.0/,xscale/1.0,1.0,1.0,1.0/,fscale/1.0/
c
      iparam(1)=0
      call uminf(func,nparam,xguess,xscale,fscale,iparam,rparam,param,
& fvalue)
c**************************************************************************
c STANDARD OUTPUT
c**************************************************************************
      write(*,*) ' '
      write(*,*) '* * * Final estimates for Psi * * *'
      write(*,*) 'mu = ',param(1)
      write(*,*) 'theta = ',param(2)
      write(*,*) 'ksi = ',param(3)
      write(*,*) 'sigma = ',param(4)
      write(*,*) ' '
      write(*,*) '* * * optimization notes * * * '
      write(*,*) 'the number of iterations is ', iparam(3)
      write(*,*) 'and the number of function evaluations is ', iparam(4)
      do 30 i = 1,8
         write(*,*) 'prediction standard errors  = ', sqrt(covv(i,i))
 30   continue
      end

c**************************************************************************
c      SUBROUTINE FUNC USED BY UMINF
c      CALLS KALMN
c**************************************************************************
      subroutine func (nparam,param,ff)
      integer nparam
      real param(nparam), ff
c
      integer   ldcovb,ldcovv,ldq,ldr,ldt,ldz,nb,nobs,ny
      parameter (nb=2,nobs=67,ny=8,ldcovb=2,ldcovv=8,ldq=2,ldr=8,
&                ldt=2,ldz=8) 
c
      integer i,iq,it,n
      real alog,alndet,b(nb),covb(ldcovb,nb),covv(ldcovv,ny),q(ldq,nb),
&      ss, t(ldt,nb),tol,v(ny),y(ny),ydata(ny,nobs),r(ldr,ny),z(ldz,nb),
&      tau(ny),ksi(ny),phi
      common ydata,r,covv
      intrinsic alog
      external amach,kalmn,hfun,rfun,wfun
c
      data tau/3.0,6.0,12.0,24.0,36.0,60.0,84.0,120.0/
c
      tol=100.0*amach(4)
      
      do 5 i = 1,ny
         ksi(i) = param(3)*tau(i)
         z(i,1) = rfun(param,4) - wfun(param,4,tau(i))
         z(i,2) = -1.0*hfun(ksi(i))
 5    continue
c
      covb(1,1) = 0.0
      covb(1,2) = 0.0
      covb(2,1) = 0.0
      covb(2,2) = 1.0
c     
      do 6 i =1,nb
         do 7 j=1,nb
            q(i,j) = covb(i,j)
 7       continue
 6    continue
c
      b(1) = 1.0
      b(2) = 0.0
      n=0
      ss=0
      alndet=0
      iq=0
      it=0
c
      phi = exp(-1.0*param(3)/nobs)
      t(1,1) = 1.0
      t(1,2) = 0.0
      t(2,1) = 0.0
      t(2,2) = phi
            
c
      do 10 i = 1,nobs
         y(1) = ydata(1,i)
         y(2) = ydata(2,i)
         y(3) = ydata(3,i)
         y(4) = ydata(4,i)
         y(5) = ydata(5,i)
         y(6) = ydata(6,i)
         y(7) = ydata(7,i)
         y(8) = ydata(8,i)
         call kalmn(ny,y,nb,z,ldz,r,ldr,it,t,ldt,iq,q,ldq,tol,b,covb,
&           ldcovb,n,ss,alndet,v,covv,ldcovv)
 10   continue
      ff=n*alog(ss/n) + alndet
      return
      end

c**************************************************************************
c UTILITY FUNCTIONS
c**************************************************************************
      real function hfun(x)
      real x
c     
      hfun = (1 - exp(-x))/x
      return
      end
c
c
      real function rfun(x,n)
      integer n
      real x(n)
c
      rfun = x(1) + x(2)*(x(4)/x(3)) - 0.5*((x(4)**2)/(x(3)**2))
      return
      end
c
c
      real function wfun(x,n,tau)
      integer n
      real x(n),tau
c
      external hfun
      real ksit,ksit2
      ksit = x(3)*tau
      ksit2 = 2.0*ksit
      wfun = hfun(ksit)*(x(2)*(x(4)/x(3)) - ((x(4)**2)/(x(3)**2))) + 
& 0.5*hfun(ksit2)*((x(4)**2)/(x(3)**2))
      return
      end
      
