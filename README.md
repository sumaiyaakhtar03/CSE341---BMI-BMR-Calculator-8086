# BMI & BMR Calculator in 8086 Assembly

A console-based **BMI (Body Mass Index), BMR (Basal Metabolic Rate), and TDEE (Total Daily Energy Expenditure) calculator** written in **8086 Assembly** for the **EMU8086** environment. The project demonstrates low-level programming through keyboard input, arithmetic, control flow, macros, procedures, and DOS interrupts.


## Features

- Collects information for multiple users in a single session.
- Prompts for gender, age, weight, height, and activity level.
- Offers weight input in kilograms or pounds and height input in meters, centimeters, or inches.
- Calculates **BMI** and classifies it as underweight, normal weight, overweight, or obese.
- Prints brief suggestions associated with the BMI category.
- Calculates **BMR** with gender-dependent constants in the implemented formula.
- Estimates **TDEE** using the program's selected activity-level multiplier, and categorizes the result into calorie-needs ranges.
- Offers the option to calculate the other measure (BMI or BMR) after the first one.
- Includes some invalid-input checks and a retry prompt.
- Contains routines intended to report the maximum and minimum BMI/BMR values among entered users.

## Technologies and concepts

- **Language:** Intel 8086 Assembly
- **Development/runtime environment:** EMU8086 (16-bit DOS-style program)
- **Concepts:** registers, arrays, loops, conditional jumps, macros, procedures, integer arithmetic, ASCII conversion, and `INT 21h` DOS services

## Project files

```text
bmi-bmr-calculator-8086/
├── main.asm       # 8086 Assembly source code
└── README.md      # Project documentation
```

## Run in EMU8086

1. Install and launch **EMU8086** on a compatible Windows environment.
2. Open `main.asm` in EMU8086.
3. Use **Compile** to assemble the program and address any assembler errors reported.
4. Run the assembled program using **Emulate/Run**.
5. Follow the on-screen prompts to provide the requested inputs and select BMI or BMR.

EMU8086 is primarily a Windows tool. On macOS, use a compatible Windows environment or other suitable 8086 assembler/emulator; this program is **not** a native macOS or Python application.

## Input and calculation flow

```text
Start
  |
  v
Choose number of users
  |
  v
Enter gender, age, weight unit and weight,
height unit and height, activity level
  |
  v
Select BMI or BMR
  |                   |
  v                   v
BMI + category      BMR + TDEE + calorie-needs category
  |                   |
  +---- Optionally calculate the other ----+
                       |
                       v
                Next user / summary
```

### BMI

The program applies the integer arithmetic version of:

`BMI = weight (kg) / [height (m)]²`

It then displays one of four BMI categories and corresponding advisory messages.

### BMR

The source implements these expressions:

- **Male:** `BMR = 10 × weight + 625 × height − 5 × age + 5`
- **Female:** `BMR = 10 × weight + 625 × height − 5 × age − 161`

The code also computes a TDEE-like value by multiplying BMR by the **integer activity selection** (1 through 5) and labels the result using fixed thresholds. This is how the supplied implementation works; it does **not** use standard fractional activity factors.

## Important implementation notes

This is an educational low-level programming project, **not a medically validated calculator**. The supplied code has not been verified to compile or produce accurate numerical output in every case. In particular:

- Numeric input and calculations use whole-number arithmetic, so conversions and BMI values lose decimal precision.
- Pounds are converted to kilograms with division by 2, and inches are converted using division by 39; both are approximate.
- The TDEE multiplier uses the numeric menu selection (1–5) rather than conventional activity-factor values.
- The declared arrays and multi-user summary routines may need debugging and testing for multiple users and all input paths.
- Do not rely on the results for medical, nutritional, or fitness decisions.

## Potential improvements

- Use fixed-point arithmetic for accurate BMI, BMR, height, and weight conversions.
- Apply validated activity factors for TDEE estimates.
- Strengthen numeric input validation and bounds checking.
- Test and correct multi-user arrays and min/max statistics.
- Improve the menu and add clearer result formatting.

## Learning outcomes

This project practices 8086 instruction-level programming, DOS character input/output, number conversion, integer arithmetic, branching, loops, and modular organization using macros and procedures.
