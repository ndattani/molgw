!======================================================================
! The following lines have been generated by a python script: input_variables.py
! Do not alter them directly: they will be overriden sooner or later by the script
! To add a new input variable, modify the script directly
! Generated by input_variables.py on 21 July 2021
!======================================================================

 real(dp),protected :: auto_auxil_fsam
 integer,protected :: auto_auxil_lmaxinc
 character(len=256),protected :: comment
 character(len=256),protected :: ecp_auxil_basis
 character(len=256),protected :: ecp_basis
 character(len=256),protected :: ecp_elements
 character(len=256),protected :: ecp_quality
 character(len=256),protected :: ecp_type
 character(len=3),protected :: eri3_genuine
 character(len=256),protected :: gaussian_type
 character(len=3),protected :: incore
 character(len=3),protected :: memory_evaluation
 character(len=256),protected :: move_nuclei
 integer,protected :: nstep
 character(len=256),protected :: scf
 real(dp),protected :: tolforce
 integer,protected :: eri3_nbatch
 integer,protected :: eri3_npcol
 integer,protected :: eri3_nprow
 real(dp),protected :: grid_memory
 integer,protected :: mpi_nproc_ortho
 integer,protected :: scalapack_block_min
 character(len=256),protected :: basis_path
 character(len=3),protected :: force_energy_qp
 character(len=3),protected :: ignore_bigrestart
 character(len=3),protected :: print_bigrestart
 character(len=3),protected :: print_cube
 character(len=3),protected :: print_wfn_files
 character(len=3),protected :: print_density_matrix
 character(len=3),protected :: print_eri
 character(len=3),protected :: print_hartree
 character(len=3),protected :: print_multipole
 character(len=3),protected :: print_pdos
 character(len=3),protected :: print_restart
 character(len=3),protected :: print_rho_grid
 character(len=3),protected :: print_sigma
 character(len=3),protected :: print_spatial_extension
 character(len=3),protected :: print_w
 character(len=3),protected :: print_wfn
 character(len=3),protected :: print_yaml
 character(len=256),protected :: read_fchk
 character(len=3),protected :: calc_dens_disc
 character(len=3),protected :: calc_q_matrix
 character(len=3),protected :: calc_spectrum
 character(len=3),protected :: print_cube_diff_tddft
 character(len=3),protected :: print_cube_rho_tddft
 character(len=3),protected :: print_dens_traj
 character(len=3),protected :: print_dens_traj_points_set
 character(len=3),protected :: print_dens_traj_tddft
 character(len=3),protected :: print_line_rho_diff_tddft
 character(len=3),protected :: print_line_rho_tddft
 character(len=3),protected :: print_tddft_matrices
 character(len=3),protected :: print_tddft_restart
 character(len=3),protected :: read_tddft_restart
 real(dp),protected :: write_step
 character(len=3),protected :: assume_scf_converged
 character(len=256),protected :: ci_greens_function
 integer,protected :: ci_nstate
 integer,protected :: ci_nstate_self
 integer,protected :: ci_spin_multiplicity
 character(len=256),protected :: ci_type
 integer,protected :: dft_core
 character(len=256),protected :: ecp_small_basis
 real(dp),protected :: eta
 character(len=3),protected :: frozencore
 character(len=3),protected :: gwgamma_tddft
 integer,protected :: ncoreg
 integer,protected :: ncorew
 integer,protected :: nexcitation
 integer,protected :: nomega_chi_imag
 integer,protected :: nomega_sigma
 integer,protected :: nomega_sigma_calc
 integer,protected :: nstep_dav
 integer,protected :: nstep_gw
 integer,protected :: nvel_projectile
 integer,protected :: nvirtualg
 integer,protected :: nvirtualw
 character(len=256),protected :: postscf
 character(len=256),protected :: postscf_diago_flavor
 character(len=256),protected :: pt3_a_diagrams
 character(len=256),protected :: pt_density_matrix
 real(dp),protected :: rcut_mbpt
 real(dp),protected :: scissor
 integer,protected :: selfenergy_state_max
 integer,protected :: selfenergy_state_min
 integer,protected :: selfenergy_state_range
 character(len=256),protected :: small_basis
 real(dp),protected :: step_sigma
 real(dp),protected :: step_sigma_calc
 character(len=256),protected :: stopping
 character(len=3),protected :: tda
 character(len=256),protected :: tddft_grid_quality
 real(dp),protected :: toldav
 character(len=3),protected :: triplet
 character(len=3),protected :: use_correlated_density_matrix
 character(len=3),protected :: virtual_fno
 real(dp),protected :: excit_dir(3)
 real(dp),protected :: excit_kappa
 character(len=256),protected :: excit_name
 real(dp),protected :: excit_omega
 real(dp),protected :: excit_time0
 integer,protected :: n_hist
 integer,protected :: n_iter
 integer,protected :: n_restart_tddft
 integer,protected :: ncore_tddft
 character(len=256),protected :: pred_corr
 character(len=256),protected :: prop_type
 real(dp),protected :: projectile_charge_scaling
 real(dp),protected :: r_disc
 character(len=3),protected :: tddft_frozencore
 real(dp),protected :: time_sim
 real(dp),protected :: time_step
 real(dp),protected :: vel_projectile(3)
 real(dp),protected :: alpha_hybrid
 real(dp),protected :: alpha_mixing
 real(dp),protected :: beta_hybrid
 real(dp),protected :: density_matrix_damping
 real(dp),protected :: diis_switch
 real(dp),protected :: gamma_hybrid
 character(len=256),protected :: grid_quality
 character(len=256),protected :: init_hamiltonian
 character(len=256),protected :: integral_quality
 real(dp),protected :: kerker_k0
 real(dp),protected :: level_shifting_energy
 real(dp),protected :: min_overlap
 character(len=256),protected :: mixing_scheme
 integer,protected :: npulay_hist
 integer,protected :: nscf
 character(len=256),protected :: partition_scheme
 character(len=256),protected :: scf_diago_flavor
 real(dp),protected :: tolscf
 real(dp),protected :: charge
 character(len=256),protected :: length_unit
 real(dp),protected :: magnetization
 integer,protected :: natom
 integer,protected :: nghost
 integer,protected :: nspin
 real(dp),protected :: temperature
 character(len=256),protected :: xyz_file


!======================================================================
