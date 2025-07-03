import QtQuick 2.15
import QtQuick.Controls 2.15

import '../../component_library/style' as Style

Item {
    id: controlId
    clip: true
    ScrollView {
        id: scrollInput
        width: parent.width
        height: parent.height
        ScrollBar.vertical.interactive: true

        ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                   ? ScrollBar.AlwaysOn
                                   : ScrollBar.AlwaysOff

        ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                        (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

        TextArea{
            id: textId
            text:"# OS LLM AI

**Established:** January 2024

**Update:** April 26, 2025

[OS LLM AI](http://www.osllm.ai/)  is a cutting-edge platform dedicated to harnessing the power of AI for creativity and productivity. Continuously evolving to meet user needs, it incorporates innovative features and updates designed to streamline workflows and enhance the user experience.



---

## About OS LLM AI:

[OS LLM AI](http://www.osllm.ai/)  provides a comprehensive suite of AI-powered tools for various applications, making advanced AI technology accessible to everyone. With a focus on user-friendly interfaces and powerful functionality, [OS LLM AI](http://www.osllm.ai/)  empowers individuals and businesses to achieve more with less effort.

---

## Key Features:

### AI Writing:
Generate, refine, and improve content effortlessly. Whether you are drafting articles, emails, or social media posts, [OS LLM AI](http://www.osllm.ai/)  ensures high-quality output tailored to your needs.

### AI Translation:
Break language barriers with accurate and seamless translation capabilities. Translate text, web pages, or documents effortlessly, ensuring smooth communication across languages.

### AI Chat:
Engage in conversations with advanced AI models and explore innovative capabilities such as **Chat with any PDF document**, enabling users to extract insights, summarize content, or interact with information within their PDF files.

### Agent Library:
Explore the **Agent Library**, a collection of pre-designed AI agents tailored for specific tasks. These agents are ready to assist with unique needs, such as research, customer support, or creative projects, saving time and boosting efficiency.

### Image Tools
- **Image Creation:** Transform your ideas into stunning visuals with advanced AI-driven art generation tools.
- **Image Mask:** Edit images with precision by creating and modifying specific areas.
- **Image Scaling:** Resize images while maintaining quality and clarity, ideal for various creative projects.

---

## Accessibility and Ease of Use:

[OS LLM AI](http://www.osllm.ai/) is available across multiple platforms, including browser extensions, mobile apps, and desktop applications. Its intuitive design ensures that users of all skill levels can get started quickly and efficiently.

---

## Empowering Creativity and Productivity:

By combining cutting-edge AI models with innovative tools, [OS LLM AI](http://www.osllm.ai/)  redefines the boundaries of what’s possible. Whether you are creating, translating, or automating tasks, [OS LLM AI](http://www.osllm.ai/)  is your ultimate partner in achieving success.

---

## Contact Us:

Feel free to reach out if you need any help or have any questions:

**Email:** Support@osllm.ai

"
            color: Style.Colors.textInformation
            anchors.fill: parent
            anchors.margins: 10
            selectionColor: "blue"
            selectedTextColor: "white"
            font.pixelSize: 14
            width: parent.width - 20
            focus: false
            clip: true
            readOnly: true
            horizontalAlignment: Text.AlignJustify
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.MarkdownText

            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }
            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }
    }
}
