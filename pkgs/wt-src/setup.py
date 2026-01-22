from setuptools import setup, find_packages

setup(
    name="wt",
    version="0.1.0",
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            "wt=wt.__main__:main",
        ],
    },
    python_requires=">=3.8",
    description="Git worktree workflow tool",
    author="Conlin Durbin",
    license="MIT",
)
