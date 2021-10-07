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
        # Create text and latex for step one
        first_line = Text('Step 1. Formulate SVM as an optimisation problem')
        equation_one = Tex('$\\max_{\\beta,\\beta_{0}} M$')
        equation_two = Tex('$\\text{subject to }\\frac{1}{||\\beta||} y_{i}(x_{i}^T \\beta+\\beta_{0}) \geq M, i = 1,...,N.$')
        
        # Position second line underneath first line
        equation_two.next_to(equation_one, DOWN)

        # Displaying text and equation
        self.play(Write(first_line))
        self.wait(1)
        self.play(ReplacementTransform(first_line, equation_one), FadeIn(equation_two))
        self.wait(2)
        self.play(FadeOut(equation_one), FadeOut(equation_two))
        # self.wait(2)

        
        
#         \begin{align}
# g(\alpha, \lambda) = \frac{1}{2}||\boldsymbol{\beta}||^{2} + C\sum_{i=1}^{n}\xi_{i} + \sum_{i=1}^{n}\alpha_{i}(1-y_{i}(\beta^{T}x_{i}+b) - \xi_{i}) + \sum_{i-1}^{n}\lambda_{i}(-\xi_{i})\\
# = \frac{1}{2}\sum_{i=1}^{m}\sum_{j=1}^{m}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}+C\sum_{i=1}^{m}\xi_{i} - \sum_{i=1}^{m}\sum_{j=1}^{m}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}x_{j}^{T} -b\underbrace{\sum_{i=1}^{m}\alpha_{i}y_{i}}_{0}+\sum_{i=1}^{m}\alpha_{i} - \sum_{i=1}^{m}\alpha_{i}\xi_{i} - \sum_{i=1}^{m}(C-\alpha_{i})\xi_{i}\\
# = \sum_{i=1}^{m}\alpha_{i} - \frac{1}{2}\sum_{i=1}^{m}\sum_{j=1}^{m}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}
# \end{align}

# \begin{align}
# \text{maximise the dual } \sum_{i=1}^{m}\alpha_{i} - \frac{1}{2}\sum_{i=1}^{m}\sum_{j=1}^{m}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}\\
# \text{subject to } 0, \leq \alpha_{i} \leq C, \sum_{i=1}^{n}y_{i}\alpha_{i} = 0
# \end{align}