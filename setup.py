import os
from setuptools import find_packages
from numpy.distutils.core import setup, Extension

# The Fortran extension for nnls_burst
nnls_sources = ['mnbrak.f90', 'nnls_burst.f90', 'dbrent.f90',
                'fit_cont_nnls.f90']
ext = Extension('pyplatefit.nnls_burst',
                [os.path.join('pyNNLS', f) for f in nnls_sources])

# Dependencies. 
install_requires = ['numpy', 'astropy', 'scipy', 'tqdm', 'joblib',
                    'lmfit', 'mpdaf', 'numdifftools']

setup(
    name='pyplatefit',
    description='Fit emission/absorption lines in MUSE spectra',
    author='Roland Bacon',
    author_email='roland.bacon@univ-lyon1.fr',
    use_scm_version=True,
    setup_requires=['setuptools_scm'],
    packages=find_packages(),
    package_data={
        'pyplatefit': ['BC03/bc_models_subset_cb08_milesx__bursts_extlam.fit',
                      'refdata/lines_table_platefit.fits']
    },
    zip_safe=False,
    include_package_data=True,
    install_requires=install_requires,
    ext_modules=[ext],
)
