from manim import * 
config.background_color = PURPLE
class  Changebackgroundcolor(Scene):
	CONFIG={
		"camera_config":{"background_color":"#475147"}
	}

class displayEquations(Scene):
    CONFIG={
		"camera_config":{"background_color":"WHITE"}
	}
    def construct(self):
        # Create Tex objects
        # Step One
        first_line = Text('Step 1. Formulate SVM as an optimisation problem')
        equation_one = Tex('$\\max_{\\beta,\\beta_{0}} M$')
        equation_two = Tex('$\\text{subject to }\\frac{1}{||\\beta||} y_{i}(x_{i}^T \\beta+\\beta_{0}) \geq M, i = 1,...,N.$')
        
        # Position second line underneath first line
        equation_two.next_to(equation_one, DOWN)

        # Displaying text and equation
        self.play(Write(first_line))
        self.wait(1)
        self.play(ReplacementTransform(first_line, equation_one), FadeIn(equation_two))
        self.wait(1)
        self.play(FadeOut(equation_one), FadeOut(equation_two))
        # self.wait(2)
        # Second step
        second_line = Text('Step 2. Reformulate for convenience')
        equation_three = Tex('$\\min_{\\beta,\\beta_{0}} \\frac{1}{2}||\\beta||^{2}$')
        equation_four = Tex('$\\text{subject to }\\frac{1}{||\\beta||} y_{i}(x_{i}^T \\beta+\\beta_{0}) \geq 1, i = 1,...,N.$')

        # Position second line underneath first line
        equation_four.next_to(equation_three, DOWN)

        # Displaying text and equations 
        self.play(Write(second_line))
        self.wait(1)
        self.play(ReplacementTransform(second_line, equation_three), FadeIn(equation_four))
        self.wait(1)
        self.play(FadeOut(equation_three), FadeOut(equation_four))

        # Third step
        third_line = Text('Step 3. Write Lagrangian (we are almost there)')
        equation_five = Tex('$\\frac{1}{2}||\\beta||^{2} C \\sum_{i=1}^{n}\\xi_{i}\\sum_{i=1}^{n}\\alpha_{i}(1-y_{i}(\\beta^{T}x_{i}+b) - \\xi_{i}) + \\sum_{i-1}^{n}\\lambda_{i}(-\\xi_{i})$')

        # Displaying text and equations
        self.play(Write(third_line))
        self.wait(1)
        self.play(ReplacementTransform(third_line, equation_five))
        self.wait(1)
        self.play(FadeOut(equation_five))

        # Fourth step 
        fourth_line = Text('Step 4. Find the dual form')
        fifth_line= Text('Here we are! This is our quadratic problem.')
        equation_six = Tex('$\\text{maximise the dual } \\sum_{i=1}^{m}\\alpha_{i} - \\frac{1}{2}\\sum_{i=1}^{m}\\sum_{j=1}^{m}\\alpha_{i}\\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}$')
        equation_seven = Tex('$\\text{subject to } 0, \\leq \\alpha_{i} \\leq C, \\sum_{i=1}^{n}y_{i}\\alpha_{i} = 0$')   

        # Position second line underneath first line
        equation_six.next_to(fifth_line, DOWN)
        equation_seven.next_to(equation_six, DOWN)

        # Displaying text and equations 
        self.play(Write(fourth_line))
        self.wait(1)
        self.play(ReplacementTransform(fourth_line, fifth_line), FadeIn(equation_six), FadeIn(equation_seven))
        self.wait(2)

