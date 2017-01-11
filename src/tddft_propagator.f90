!=========================================================================
! This file is part of MOLGW.
! Author: Fabien Bruneval
!
! This module contains
! propagation of the wavefunction in time
!
!=========================================================================
!module m_tddft_propagator
! use m_definitions
! use m_basis_set 
! use m_scf_loop
! use m_memory
! use m_hamiltonian
!contains


!=========================================================================
subroutine calculate_propagation(nstate, basis, occupation, energy, s_matrix, c_matrix,hamiltonian_kinetic,hamiltonian_nucleus)
 use m_definitions
 use m_basis_set
 use m_scf_loop
 use m_memory
 use m_hamiltonian
 use m_inputparam
 use m_dft_grid
 use m_tools
 implicit none

!=====
 type(basis_set),intent(in)      :: basis
 integer                         :: nstate 
 real(dp),intent(in)             :: energy(nstate,nspin)
 real(dp),intent(in)             :: s_matrix(basis%nbf,basis%nbf)
 real(dp),intent(in)             :: c_matrix(basis%nbf,nstate,nspin) 
 real(dp),intent(in)             :: occupation(nstate,nspin)
 real(dp),intent(in)             :: hamiltonian_kinetic(basis%nbf,basis%nbf)
 real(dp),intent(in)             :: hamiltonian_nucleus(basis%nbf,basis%nbf)
!=====
 integer                    :: itau, jtau, ntau, idir, info, ispin
 integer                    :: file_time_data, file_excit_field, file_check_matrix
 integer                    :: file_eexchange
 real(dp)                   :: t_min, t_max, t_step, t_cur, excit_field(3)
 real(dp),allocatable       :: s_matrix_inv(:,:)
 real(dp),allocatable       :: p_matrix(:,:,:)
 real(dp),allocatable       :: dipole_basis(:,:,:)
 real(dp),allocatable       :: dipole_time(:,:)
 complex(dpc), allocatable  :: l_matrix(:,:,:) ! Follow the notation of M.A.L.Marques, C.A.Ullrich et al, 
 complex(dpc),allocatable   :: b_matrix(:,:,:) ! TDDFT Book, Springer (2006), p205
 complex(dpc),allocatable   :: m_unity(:,:)
 complex(dpc),allocatable   :: hamiltonian_fock_cmplx(:,:,:)
 complex(dpc),allocatable   :: c_matrix_cmplx(:,:,:)
 complex(dpc),allocatable   :: p_matrix_cmplx(:,:,:)
 complex(dpc),allocatable   :: check_matrix(:,:)
 character(len=36)          :: check_format
 call init_dft_grid(grid_level)
 
 t_min=0.0_dp
 t_max=200.0_dp
 t_step=0.01_dp

allocate(s_matrix_inv(basis%nbf,basis%nbf))
allocate(p_matrix(basis%nbf,basis%nbf,nspin))
allocate(hamiltonian_fock_cmplx(basis%nbf,basis%nbf,nspin))
allocate(c_matrix_cmplx(basis%nbf,nstate,nspin))
allocate(p_matrix_cmplx(basis%nbf,basis%nbf,nspin))
allocate(l_matrix(basis%nbf,basis%nbf,nspin))
allocate(b_matrix(basis%nbf,basis%nbf,nspin))
allocate(m_unity(basis%nbf,basis%nbf))
allocate(dipole_basis(3,basis%nbf,basis%nbf))
allocate(check_matrix(basis%nbf,basis%nbf))

  c_matrix_cmplx(:,:,:)=c_matrix(:,:,:) 
  p_matrix_cmplx(:,:,:)=p_matrix(:,:,:)

 call invert(basis%nbf,s_matrix,s_matrix_inv)  
 call fill_unity(m_unity,basis%nbf)
 call calculate_dipole_basis_cmplx(basis,dipole_basis)

ntau=int((t_max-t_min)/t_step)
allocate(dipole_time(3,2*ntau))

dipole_time(:,:)=0.0_dp

open(newunit=file_time_data,file="time_data.dat")
open(newunit=file_excit_field,file="excitation.dat")
open(newunit=file_check_matrix,file="check_matrix.dat")

 do idir=1,3
   call print_square_2d_matrix_real("dipole_basis", dipole_basis(idir,:,:) , basis%nbf, file_check_matrix, 3 )
 end do 

!write(file_time_data,*) "# t_cur real(c_matrix_cmplx(1,1,1)), aimag(c_matrix_cmplx(1,1,1)), real(p_matrix_cmplx(2,1,1)), aimag(p_matrix_cmplx(2,1,1))"

!********start time loop*************
do itau=1,ntau
  t_cur=t_min+itau*t_step
!  write(file_time_data,"(F9.4)",advance='no') t_cur
  write(stdout,"(A,F9.4)") "t_cur = ", t_cur
  write(file_check_matrix,*) "========================="
  write(file_check_matrix,"(A,F9.4)") "t_cur = ", t_cur
  !--Hamiltonian - Hartree Exchange Correlation---
      call calculate_hamiltonian_hxc_ri_cmplx(basis,nstate,basis%nbf,basis%nbf,basis%nbf,nstate,occupation, &
               c_matrix_cmplx,hamiltonian_fock_cmplx,file_check_matrix)
  do ispin=1, nspin  
    !--ChEcK c_MaTrIx--
     write(file_check_matrix,"(A,I2)") "ispin = ", ispin
     check_matrix = MATMUL(MATMUL(s_matrix(:,:) ,c_matrix_cmplx(:,:,nspin) ) ,TRANSPOSE(CONJG(c_matrix_cmplx(:,:,nspin)))  )
     call print_square_2d_matrix_cmplx("S*C*C**H = ",check_matrix,basis%nbf,file_check_matrix,4)
     
     !------
     !--Hamiltonian - Static part--
      hamiltonian_fock_cmplx(:,:,ispin) = hamiltonian_fock_cmplx(:,:,ispin) + hamiltonian_kinetic(:,:) + hamiltonian_nucleus(:,:)
    !--Hamiltonian - Excitation--
      call calculate_excit_field(t_cur,excit_field)
      write(file_excit_field,*) t_cur, excit_field
      do idir=1,3
             hamiltonian_fock_cmplx(:,:,ispin) = hamiltonian_fock_cmplx(:,:,ispin) - &
                                 & dipole_basis(idir,:,:) * excit_field(idir)
      end do     
      call print_square_2d_matrix_cmplx("Hamiltonian = ",hamiltonian_fock_cmplx,basis%nbf,file_check_matrix,4)
!-------------------------------
       l_matrix(:,:,ispin) = m_unity + im * t_step / 2.0_dp * matmul( s_matrix_inv,hamiltonian_fock_cmplx(:,:,ispin)  )
       b_matrix(:,:,ispin) = m_unity - im * t_step / 2.0_dp * matmul( s_matrix_inv,hamiltonian_fock_cmplx(:,:,ispin)  )
       call invert(basis%nbf , l_matrix(:,:,ispin))
       c_matrix_cmplx(:,:,ispin) = matmul( l_matrix(:,:,ispin),matmul( b_matrix(:,:,ispin),c_matrix_cmplx(:,:,ispin) ) )
      
      call static_dipole_cmplx(nstate,basis,occupation,c_matrix_cmplx,dipole_time(:,itau))
   
   end do !spin loop
end do
!********end time loop*******************

!---Fourier Transform of dipole_time---
! plan = fftw_plan_dft_1d(2*ntau,dipole_r(1,:),trans_dipole_r(1,:),FFTW_FORWARD,FFTW_ESTIMATE)
!  call fftw_execute_dft(plan,dipole_r(1,:),trans_dipole_r(1,:))
!   call fftw_destroy_plan(plan)

 call destroy_dft_grid()

end subroutine calculate_propagation


!==========================================
subroutine calculate_excit_field(t_cur,excit_field)
   use m_definitions
   implicit none
   real(dp),intent(in)   :: t_cur ! time in au
   real(dp),intent(inout)   :: excit_field(3) ! electric field in 3 dimensions
!=====
   real(dp)              :: omega, kappa ! Follow notations from article Lopata et al. Modeling Fast Electron ... J. Chem Theory Comput, 2011
   real(dp)              :: time_0
   integer               :: dir
!=====   
   kappa=5.01_dp
   omega=0.2_dp
   time_0=10.0_dp
   dir=1
  
   excit_field(:) = 0.0_dp
   excit_field(dir) = kappa * exp( -(t_cur-time_0)**2 / 2.0_dp / omega**2 )

end subroutine calculate_excit_field


!=======================================
subroutine fill_unity(m_unity,M)
        use m_definitions
        implicit none
        integer, intent(in) :: M
        complex(dpc) :: m_unity(M,M)
        integer :: i,j
        do i=1,M
         do j=1,M
             if (i == j) then
                     m_unity(i,j)=1.0_dp
             else
                     m_unity(i,j)=0.0_dp
             end if
          end do
        end do
end subroutine

!=========================================================================
!end module m_tddft_propagator
!=========================================================================


!=======================================
subroutine print_square_2d_matrix_cmplx (desc,matrix_cmplx,size_m,write_unit,prec)
      use m_definitions
      implicit none
      integer, intent(in)      :: prec ! precision
      integer, intent(in)      :: size_m, write_unit
      complex(dpc),intent(in)  :: matrix_cmplx(size_m,size_m)
      character(*),intent(in)  :: desc
!=====
      character(100)  :: write_format1, write_format2
      integer            :: ivar

      write(write_format1,*) '(',size_m," ('(',F", prec+4, ".", prec,"' ,',F", prec+4, ".",prec,",')  ') " ,')' ! (  1.01 ,  -0.03)  (  0.04 ,  0.10) 
      write(write_format2,*) '(',size_m," (F", prec+4, ".", prec,"' +  i',F", prec+4, ".",prec,",'  ') " ,')'   ! 1.01 +  i  -0.03    0.03 +  i  0.10
      write(write_unit,*) desc
      do ivar=1,size_m
           write(write_unit,write_format1) matrix_cmplx(ivar,:)          
      end do
end subroutine print_square_2d_matrix_cmplx


!=======================================
subroutine print_square_2d_matrix_real (desc,matrix_real,size_m,write_unit,prec)
      use m_definitions
      implicit none
      integer, intent(in)      :: prec ! precision
      integer, intent(in)      :: size_m, write_unit
      real(dp),intent(in)      :: matrix_real(size_m,size_m)
      character(*),intent(in)  :: desc
!=====
      character(100)  :: write_format1
      integer            :: ivar

      write(write_format1,*) '(',size_m," (F", prec+4, ".", prec,') ' ,')' 
      write(write_unit,*) desc
      do ivar=1,size_m
           write(write_unit,write_format1) matrix_real(ivar,:)          
      end do
end subroutine print_square_2d_matrix_real

