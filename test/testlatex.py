import matplotlib.pyplot as plt


def render_latex(formula, filename='/home/denstiny/a.png', dpi=300):
    # 配置Matplotlib: 使用LaTeX渲染器
    plt.rc('text', usetex=True)
    plt.rc('font', family='serif')

    # 创建一个图和一个轴
    fig = plt.figure()
    ax = fig.add_subplot(111)

    # 设置轴的位置，使其不可见
    ax.set_frame_on(False)
    ax.get_xaxis().set_ticks([])
    ax.get_yaxis().set_ticks([])

    # 在轴上放置文本(即渲染的LaTeX公式)
    ax.text(0.5, 0.5, f'${formula}$', fontsize=12, ha='center', va='center')

    # 保存图片
    fig.savefig(filename, dpi=dpi)

    # 关闭图形对象
    plt.close(fig)


# LaTeX公式，您可以根据需要更改它
latex_formula = r'sum_{i=0}^infty x_i'

# 渲染LaTeX公式为图片
render_latex(latex_formula)
