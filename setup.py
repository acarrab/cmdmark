from setuptools import setup, find_packages
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    readme=f.read()


setup(
    name='cmdmark',
    version='1.0.0',
    description='Adds command marking functionality for bash when included as an alias',
    long_description=readme,
    url='https://github.com/acarrab/cmd-mark',
    author='Angelo Carrabba',
    author_email='acarrabba6@gmail.com',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Topic :: Bash and Linux Development',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    keywords='Bash command alias manager',
    packages=find_packages(exclude=['docs']),
    install_requires=['regex'],
    package_data={
        'runcommands': ['package_data.dat']
    },
    entry_points={
        'console_scripts': [
            'cmdmark=cmdmark:main',
        ]
    },
)
