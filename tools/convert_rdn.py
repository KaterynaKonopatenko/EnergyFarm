"""Convert OREE monthly price_DAM_IDM_MM.YYYY.xls files to one hourly CSV.

Usage: python3 convert_rdn.py <input_dir> <output_csv>
Needs: pip install xlrd

Reads sheet "Ціна_РДН" (DAM, OES Ukraine, UAH/MWh, without VAT).
Output always has 24 rows per day, local Kyiv time:
- 25-hour day (DST end): the two 03:00 hours are averaged.
- 23-hour day (DST start): missing 03:00 = average of 02:00 and 04:00.
"""
import csv
import re
import sys
from pathlib import Path

import xlrd

SHEET = "Ціна_РДН"
FIRST_ROW = 3  # rows 0-2 are titles


def read_month(path):
    book = xlrd.open_workbook(path, ignore_workbook_corruption=True)
    sheet = book.sheet_by_name(SHEET)
    days = {}
    for r in range(FIRST_ROW, sheet.nrows):
        day = int(sheet.cell_value(r, 0))
        vals = [sheet.cell_value(r, c) for c in range(1, sheet.ncols)]
        days[day] = [float(v) for v in vals if v != ""]
    return days


def to_24(vals):
    if len(vals) == 25:
        return vals[:3] + [(vals[3] + vals[4]) / 2] + vals[5:]
    if len(vals) == 23:
        return vals[:3] + [(vals[2] + vals[3]) / 2] + vals[3:]
    if len(vals) != 24:
        raise ValueError(f"unexpected hour count {len(vals)}")
    return vals


def main(src, dst):
    files = {}
    for f in Path(src).glob("*.xls"):
        m = re.search(r"(\d{2})\.(\d{4})", f.name)
        if m:
            files[(int(m[2]), int(m[1]))] = f  # duplicates collapse
    with open(dst, "w", newline="") as out:
        w = csv.writer(out, lineterminator="\n")
        w.writerow(["datetime", "price_uah_mwh"])
        for (y, mo) in sorted(files):
            month = read_month(files[(y, mo)])
            for d in sorted(month):
                for h, p in enumerate(to_24(month[d])):
                    w.writerow([f"{y}-{mo:02d}-{d:02d}T{h:02d}:00",
                                f"{p:.2f}"])


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
