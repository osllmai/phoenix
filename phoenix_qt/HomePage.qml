import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    id: root
    width: 1229 - 24 - 70
    height: 685 - 48

    property color backgroundPageColor
    property color backgroungColor
    property color glowColor
    property color boxColor
    property color headerColor
    property color normalButtonColor
    property color selectButtonColor
    property color hoverButtonColor
    property color fillIconColor
    property color iconColor

    property color titleTextColor
    property color informationTextColor
    property color selectTextColor

    property var fontFamily

    signal chatViewRequested1()

    Rectangle {
        id: homePageId
        color: root.headerColor
        radius: 4
        anchors.fill: parent

        Rectangle {
            id: listModelId
            color: parent.color
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerId.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
            radius: 4

            Rectangle {
                id: itemListId
                anchors.fill: parent
                color: root.backgroundPageColor
                radius: 4

                ColumnLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 50
                    anchors.rightMargin: 50
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    GridView {
                        id: gridView

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        cacheBuffer: Math.max(0, gridView.contentHeight)

                        cellWidth: Math.max(100, (parent.width)/3)
                        cellHeight: Math.max(100, (parent.height)/2)
                        model: ListModel {
                           id: model
                           ListElement {title: "Chat" ;
                                            icon:"images/Phoenix.svg" ;
                                            about:"Phoenix: A multi-platform, open-source application built with Qt QML. It features a chatbot interface that interacts with documents locally, eliminating the need for an internet connection or a GPU. Phoenix leverages Indox and IndoxJudge to deliver high accuracy and eliminate hallucinations, ensuring reliable results, particularly in the healthcare field." ;
                                            gitHubLink:"" ;
                                            notebookLink:"";
                                            goPage: 1
                           }
                           ListElement {title: "Phoenix cli" ;
                                            icon:"images/image5.svg" ;
                                            about:"Phoenix_cli is a command-line interface (CLI) tool developed by osllm.ai for running Large Language Models ( LLMs) on your local machine. Built on top of the Phoenix library, a C++ library designed for executing large language models, Phoenix_cli allows you to: Run models locally without relying on a server or cloud-based service." ;
                                            gitHubLink:"https://github.com/osllmai/phoenix_cli" ;
                                            notebookLink:"";
                                            goPage:-1
                           }
                           ListElement {title: "InDox" ;
                                            icon:"images/image6.svg" ;
                                            about:"Indox is an advanced search and retrieval technique that efficiently extracts data from diverse document types, including PDFs and HTML, using online or offline large language models such as Openai, Hugging Face , etc." ;
                                            gitHubLink:"https://github.com/osllmai/inDox" ;
                                            notebookLink:"https://colab.research.google.com/github/osllmai/inDox/blob/master/Demo/openai_unstructured.ipynb";
                                            goPage:-1
                           }
                           ListElement {title: "IndoxJudge" ;
                                            icon:"images/image3.svg" ;
                                            about:"IndoxJudge offers a comprehensive set of evaluation metrics to assess the performance and quality of large language models (LLMs). Whether you're a researcher, developer, or enthusiast, this toolkit provides essential tools to measure various aspects of LLMs, including knowledge retention, bias, toxicity, and more." ;
                                            gitHubLink:"https://github.com/osllmai/indoxJudge" ;
                                            notebookLink:"https://colab.research.google.com/github/osllmai/inDoxJudge/blob/main/examples/safety_evaluator.ipynb";
                                            goPage:-1
                           }
                           ListElement {title: "IndoxGen" ;
                                            icon:"images/image4.svg" ;
                                            about:"IndoxGen is a state-of-the-art, enterprise-ready framework designed for generating high-fidelity synthetic data. Leveraging advanced AI technologies, including Large Language Models (LLMs) and incorporating human feedback loops, IndoxGen offers unparalleled flexibility and precision in synthetic data creation across various domains and use cases." ;
                                            gitHubLink:"https://github.com/osllmai/IndoxGen" ;
                                            notebookLink:"https://colab.research.google.com/github/osllmai/indoxGen/blob/master/examples/generated_with_llm_judge.ipynb"
                                            goPage:-1
                           }
                        }

                        delegate:Rectangle{
                            width: gridView.cellWidth
                            height: gridView.cellHeight
                            color: root.backgroundPageColor
                            DashbordItem {
                                id: indoxItem
                                anchors.fill: parent
                                anchors.margins: 20
                                myTextId: model.title
                                myIcon: model.icon
                                about: model.about
                                gitHubLink: model.gitHubLink
                                notebookLink: model.notebookLink
                                goPage: model.goPage

                                backgroundPageColor: root.backgroundPageColor
                                backgroungColor: window.backgroungColor
                                glowColor: window.glowColor
                                boxColor: root.boxColor
                                headerColor: root.headerColor
                                normalButtonColor: root.normalButtonColor
                                selectButtonColor: root.selectButtonColor
                                hoverButtonColor: root.hoverButtonColor
                                fillIconColor: root.fillIconColor

                                titleTextColor: root.titleTextColor
                                informationTextColor: root.informationTextColor
                                selectTextColor: root.selectTextColor

                                fontFamily: root.fontFamily

                                Connections{
                                    target: indoxItem
                                    function onChatViewRequested2() {
                                        chatViewRequested1()
                                    }
                                }
                            }
                        }

                        onContentHeightChanged: {
                            if (atYEnd)
                                scrollToEnd()
                        }
                    }
                }
            }
        }
        Rectangle{
            id:headerId
            width: parent.width
            height: 80
            color: parent.color
            radius: 4
            Text {
                id: phoenixId
                text: qsTr("Welcome to Phoenix!")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 24
                anchors.topMargin: 15
                font.pixelSize: 20
                font.styleName: "Bold"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: root.fontFamily
                color: root.titleTextColor
            }

            Text {
                id: informationText
                width: 50
                height: 20
                color: root.informationTextColor
                text: qsTr("Get Started.")
                anchors.left: parent.left
                anchors.top: phoenixId.bottom
                anchors.leftMargin: 24
                anchors.topMargin: 5
                font.pixelSize: 16
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: root.fontFamily
            }
        }
    }

}
