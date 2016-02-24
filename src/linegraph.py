#!/usr/bin/python2
# coding: utf-8
"""
This script plots a line graph using the raw data from Qualimap output in order
to visualize the quality parameters of a set of sequencing reads.

This script should also work with of files containing numeric data in two
columns and optionally, comments starting with '#'.

- The two columns in input files MUST be numeric.
- All the input files MUST contain the same number of data lines.
- All the input files SHOULD contain the same kind of data.

# Usage example

In order to plot the mapping quality of a sequencing data set in BAM format:

1. Obtain the data from qualimap from all files
    (i.e. `qualimap bamqc -bam sorted1.bam -outdir dir1`).

2. Plot the mapping data of all data sets:

    ```
    lineplot.py -o mapping_quality_set1.png dir1/mapping_data1.txt [...] \
        dirN/mapping_dataN.txt
    ```
"""
import argparse
from matplotlib import pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-o', '--output', default='lineplot.png', help='Name for the output graph.')
    #parser.add_argument('-t', '--title', default=None, help='Title for the graph.'
    parser.add_argument('files', nargs='+', help='A list of filenames containing the data to plot.')
    return parser.parse_args()

def lineplot(filenames, output):
    """Reads the info from the `filenames` and plots them to `output`."""

    quals = {}
    bins = []
    for path in filenames:
        quals[path] = []
        with open(path, 'r') as f:
            for l in f.readlines():
                if not l.startswith('#'):
                    (bin, qual) = l.split()
                    quals[path].append(qual)
                    if not bin in bins:
                        bins.append(bin)

    for q in quals:
        plt.plot(bins, quals[q], '-')

    plt.savefig(output)


if __name__ == "__main__":
    args = parse_args()
    lineplot(args.files, args.output)
