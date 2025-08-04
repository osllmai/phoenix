import QtQuick 2.15
import QtQuick.Controls 2.15

import '../../component_library/style' as Style

Item {
    id: controlId
    clip: true

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 10
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true

        contentWidth: scrollView.width

        Label {
            id: labelId
            width: scrollView.width - 15
            textFormat: Text.RichText
            wrapMode: Text.Wrap
            font.pixelSize: 14
            color: Style.Colors.textInformation
            horizontalAlignment: Text.AlignJustify
            anchors.margins: 10

            text: "
                <h2>OS LLM AI</h2>

                <p><strong>Established:</strong> January 2024<br/>
                <strong>Update:</strong> April 26, 2025</p>

                <p>
                <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none; font-weight:bold;'>OS LLM AI</a> is a cutting-edge platform dedicated to harnessing the power of AI for creativity and productivity. Continuously evolving to meet user needs, it incorporates innovative features and updates designed to streamline workflows and enhance the user experience.
                </p>

                <h3>About OS LLM AI:</h3>
                <p><a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> provides a comprehensive suite of AI-powered tools for various applications, making advanced AI technology accessible to everyone. With a focus on user-friendly interfaces and powerful functionality, <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> empowers individuals and businesses to achieve more with less effort.</p>

                <h3>Key Features:</h3>

                <h4>AI Writing:</h4>
                <p>Generate, refine, and improve content effortlessly. Whether you are drafting articles, emails, or social media posts, <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> ensures high-quality output tailored to your needs.</p>

                <h4>AI Translation:</h4>
                <p>Break language barriers with accurate and seamless translation capabilities. Translate text, web pages, or documents effortlessly, ensuring smooth communication across languages.</p>

                <h4>AI Chat:</h4>
                <p>Engage in conversations with advanced AI models and explore innovative capabilities such as <strong>Chat with any PDF document</strong>, enabling users to extract insights, summarize content, or interact with information within their PDF files.</p>

                <h4>Agent Library:</h4>
                <p>Explore the <strong>Agent Library</strong>, a collection of pre-designed AI agents tailored for specific tasks. These agents are ready to assist with unique needs, such as research, customer support, or creative projects, saving time and boosting efficiency.</p>

                <h4>Image Tools</h4>
                <ul>
                    <li><strong>Image Creation:</strong> Transform your ideas into stunning visuals with advanced AI-driven art generation tools.</li>
                    <li><strong>Image Mask:</strong> Edit images with precision by creating and modifying specific areas.</li>
                    <li><strong>Image Scaling:</strong> Resize images while maintaining quality and clarity, ideal for various creative projects.</li>
                </ul>

                <h3>Accessibility and Ease of Use:</h3>
                <p><a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> is available across multiple platforms, including browser extensions, mobile apps, and desktop applications. Its intuitive design ensures that users of all skill levels can get started quickly and efficiently.</p>

                <h3>Empowering Creativity and Productivity:</h3>
                <p>By combining cutting-edge AI models with innovative tools, <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> redefines the boundaries of what’s possible. Whether you are creating, translating, or automating tasks, <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> is your ultimate partner in achieving success.</p>

                <h3>Contact Us:</h3>
                <p>Feel free to reach out if you need any help or have any questions:</p>
                <p><strong>Email:</strong> Support@osllm.ai</p>
<br>
            "

            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }

            height: implicitHeight

            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }
    }
}
