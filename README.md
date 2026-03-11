# Arqui1 - Project 2
## Minutes

### Meetings
Meetings at least once per week, **Mondays at 8:00 PM**.

---

## Python

1. Create a Python program that allows understanding how the **bilinear interpolation algorithm** works.

2. Create a Python program that loads a **grayscale image**, divides the image into **4×4 quadrants**, and allows selecting one of those quadrants to apply the **bilinear interpolation algorithm**.

---

## ARM / RISC-V

1. Create a program in **ARM or RISC-V assembly** that applies the **bilinear interpolation algorithm** to a small matrix. Pay attention to **multiplication and division operations**, which may involve floating-point arithmetic. Investigate alternative methods such as **successive additions and subtractions**. The idea is to use **simple instructions and addressing modes** of the language.

2. Attempt to implement the program using **more specialized instructions** and evaluate both solutions.

**Start date:** Thursday, September 26.

**Proposal:**  
Emanuel Marín and Kun Zheng must independently implement the algorithm using **ARM or RISC-V**. Afterwards, the solutions will be reviewed and discussed to obtain a **final unified solution**.

**Deadline:** Monday, September 30.  
The final solution should be ready by this date. Verify whether it needs to be shown to the professor.

---

## ISA

**Start date:** Tuesday, October 1.

**Proposal:**  
Starting Tuesday, Emanuel Marín and Kun Zheng should begin holding meetings to **design the ISA and complete the green card**. Jessica Espinoza is encouraged to participate in these meetings as well. It may be useful to **reserve a room in the Learning Commons** for working sessions.

Once the ISA is ready, the program previously implemented in **ARM or RISC-V** must be translated to the new ISA. José Vargas should also participate in this stage.

**Deadline:** Friday, October 4.  
The ISA should be **approved by the professor** by this date.

---

## Compiler

**Proposal:**  
The development of the **compiler** will be led by Jessica Espinoza (which is why it is important for her to participate in the ISA design meetings). Kun Zheng is expected to assist with the **lexical, syntactic, and semantic analysis** if he already has experience in these topics. Emanuel Marín may also help later if necessary.

**Deadline:**  
The compiler should be **completed or significantly advanced before the full pipeline processor implementation**, so that testing can begin.

---

## Pipeline Processor

**Proposal:**  
The development of the **pipeline microarchitecture** will be handled by Emanuel Marín. Once the ISA is defined, Emanuel will have **one week to evaluate the design and inform the group if additional help is needed**.

**Deadline:**  
It should be ready **one and a half weeks before the final project deadline**, allowing enough time for integration testing.

---

## JTAG

**Proposal:**  
The **implementation, integration, and usage of JTAG** will be handled by José Vargas. It should be clarified with the professor whether it is necessary to **implement JTAG from scratch** or if the **JTAG provided by Quartus** can be used (see the **Platform Design section in Quartus**).

**Deadline:**  
It should be ready **one week before the project submission**.

---

## VGA Controller

**Proposal:**  
José Vargas and/or Jessica Espinoza will be responsible for developing the **VGA controller**, initially in a **separate project**. The controller should read data from memory and allow:

- Displaying the **complete original image with a 4×4 quadrant division**
- Selecting and viewing a **specific quadrant** (before applying bilinear interpolation)
- Loading into memory the **quadrant after applying the interpolation algorithm** and displaying it

**Deadline:**  
It should be ready **one and a half weeks before the project submission**, in order to allow time to develop the HDMI controller.

---

## HDMI Controller (+20 pts)

**Proposal:**  
José Vargas and/or Jessica Espinoza will develop the **HDMI controller** once the VGA controller is fully functional.

**Deadline:**  
It should be ready **half a week before the project submission**.

---

## Mouse/Keyboard Driver (+20 pts)

**Proposal:**  
Emanuel Marín and/or Kun Zheng will develop the **mouse/keyboard driver**.

**Deadline:**  
It should be ready **half a week before the project submission**.

---

## RGB Support (+10 pts)

**Proposal:**  
Adding support for **color images (RGB)** will be handled by Emanuel Marín.

**Deadline:**  
It should be ready **half a week before the project submission**.

---

## Developers

- **Jessica Espinoza** - https://github.com/Jespinoza1703  
- **Emanuel Marín** - https://github.com/MarinGE23  
- **José Vargas** - https://github.com/JoseAndresVargasTorres  
- **Kun Zheng** - https://github.com/kunZhen
