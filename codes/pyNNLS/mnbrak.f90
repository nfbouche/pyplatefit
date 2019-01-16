SUBROUTINE mnbrak(ax,bx,cx,fa,fb,fc,func,keep_inside)
      real(kind=8) :: ax,bx,cx,fa,fb,fc,func,GOLD,GLIMIT,TINY
      external :: func
      parameter (GOLD=1.618034d0, GLIMIT=100.d0, TINY=1.d-20)
      real(kind=8) :: dum,fu,q,r,u,ulim,ax0, bx0
      integer :: count
!     Added 7/11/02 JB to avoid problems with continuum fitting.
      logical :: keep_inside

      fa=func(ax)
      fb=func(bx)

!      write(*, *) 'in mnbrak.f90 now', keep_inside, fa, fb, ax, bx
      if(fb.gt.fa)then
        dum=ax
        ax=bx
        bx=dum
        dum=fb
        fb=fa
        fa=dum
      endif
      ax0=ax
      bx0=bx

      cx=bx+GOLD*(bx-ax)
      fc=func(cx)
1     if(fb.ge.fc)then
        r=(bx-ax)*(fb-fc)
        q=(bx-cx)*(fb-fa)
        u=bx-((bx-cx)*q-(bx-ax)*r)/(2.*sign(max(dabs(q-r),TINY),q-r))
        ulim=bx+GLIMIT*(cx-bx)
        if((bx-u)*(u-cx).gt.0.0d0)then
          fu=func(u)
          if(fu.lt.fc)then
            ax=bx
            fa=fb
            bx=u
            fb=fu
            return
          else if(fu.gt.fb)then
            cx=u
            fc=fu
            return
          endif
          u=cx+GOLD*(cx-bx)
          fu=func(u)
        else if((cx-u)*(u-ulim).gt.0.0d0)then
          fu=func(u)
          if(fu.lt.fc)then
            bx=cx
            cx=u
            u=cx+GOLD*(cx-bx)
            fb=fc
            fc=fu
            fu=func(u)
          endif
        else if((u-ulim)*(ulim-cx).ge.0.0d0)then
          u=ulim
          fu=func(u)
        else
          u=cx+GOLD*(cx-bx)
          fu=func(u)
        endif
        ax=bx
        bx=cx
        cx=u
        fa=fb
        fb=fc
        fc=fu
        if (keep_inside .and. (ax .lt. ax0 .or. bx .gt. bx0)) then
           keep_inside=.false.
!           write(*,*) ax, ax0, bx, bx0, keep_inside
           return
        endif
!        write(*,*) 'COUNT=', count, ax,bx,cx,fa,fb,fc
        count=count+1
        goto 1
      endif
      return

      end SUBROUTINE
