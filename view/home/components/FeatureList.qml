import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: control
    clip:true

    function calculationCellWidth(){
        if(gridView.width >1650)
            return gridView.width/5;
        else if(gridView.width >1300)
            return gridView.width/4;
        else if(gridView.width >950)
            return gridView.width/3;
        else if(gridView.width >550)
            return gridView.width/2;
        else
            return Math.max(gridView.width,300);
    }

    GridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: 15
        cacheBuffer: Math.max(0, gridView.contentHeight)

        cellWidth: control.calculationCellWidth()
        cellHeight: 300

        interactive: gridView.contentHeight > gridView.height
        boundsBehavior: gridView.interactive ? Flickable.StopAtBounds : Flickable.DragOverBounds

        flickDeceleration: 200
        maximumFlickVelocity: 12000

        ScrollBar.vertical: ScrollBar {
            policy: gridView.contentHeight > gridView.height
                    ? ScrollBar.AlwaysOn
                    : ScrollBar.AlwaysOff
        }
        clip: true

        model: ListModel {
            id: model
            ListElement {title: "Chat" ;
                            icon:"qrc:/media/icon/phoenix.svg" ;
                            about:"Phoenix: A multi-platform, open-source application built with Qt QML. It features a chatbot interface that interacts with documents locally, eliminating the need for an internet connection or a GPU. Phoenix leverages Indox and IndoxJudge to deliver high accuracy and eliminate hallucinations, ensuring reliable results, particularly in the healthcare field." ;
                            gitHubLink:"" ;
                            notebookLink:"";
                            goPage: 1
            }
            // ListElement {title: "Phoenix cli" ;
            //                 icon:"qrc:/media/icon/phoenixCli.svg" ;
            //                 about:"Phoenix_cli is a command-line interface (CLI) tool developed by osllm.ai for running Large Language Models ( LLMs) on your local machine. Built on top of the Phoenix library, a C++ library designed for executing large language models, Phoenix_cli allows you to: Run models locally without relying on a server or cloud-based service." ;
            //                 gitHubLink:"https://github.com/osllmai/phoenix_cli" ;
            //                 notebookLink:"";
            //                 goPage:-1
            // }
            ListElement {title: "InDox" ;
                            icon:"qrc:/media/icon/inDox.svg" ;
                            about:"Indox is an advanced search and retrieval technique that efficiently extracts data from diverse document types, including PDFs and HTML, using online or offline large language models such as Openai, Hugging Face , etc." ;
                            gitHubLink:"https://github.com/osllmai/inDox" ;
                            notebookLink:"https://github.com/osllmai/inDox/blob/master/cookbook/indoxArcg/openai_unstructured.ipynb";
                            goPage:-1
            }
            ListElement {title: "IndoxJudge" ;
                            icon:"qrc:/media/icon/indoxJudge.svg" ;
                            about:"IndoxJudge offers a comprehensive set of evaluation metrics to assess the performance and quality of large language models (LLMs). Whether you're a researcher, developer, or enthusiast, this toolkit provides essential tools to measure various aspects of LLMs, including knowledge retention, bias, toxicity, and more." ;
                            gitHubLink:"https://github.com/osllmai/indoxJudge" ;
                            notebookLink:"https://colab.research.google.com/github/osllmai/inDoxJudge/blob/main/examples/safety_evaluator.ipynb";
                            goPage:-1
            }
            ListElement {title: "IndoxGen" ;
                            icon:"qrc:/media/icon/indoxGen.svg" ;
                            about:"IndoxGen is a state-of-the-art, enterprise-ready framework designed for generating high-fidelity synthetic data. Leveraging advanced AI technologies, including Large Language Models (LLMs) and incorporating human feedback loops, IndoxGen offers unparalleled flexibility and precision in synthetic data creation across various domains and use cases." ;
                            gitHubLink:"https://github.com/osllmai/IndoxGen" ;
                            notebookLink:"https://colab.research.google.com/github/osllmai/indoxGen/blob/master/examples/generated_with_llm_judge.ipynb"
                            goPage:-1
            }
        }
        delegate: Rectangle{
           width: gridView.cellWidth
           height: gridView.cellHeight
           color: "#00ffffff"

           FeatureDelegate {
               id: indoxItem
               anchors.fill: parent
               anchors.margins:/* indoxItem.hovered? 18: 20*/ 18
               myText: model.title
               myIcon: model.icon
               about: model.about
               gitHubLink: model.gitHubLink
               notebookLink: model.notebookLink
               goPage: model.goPage
               Behavior on anchors.margins{ NumberAnimation{ duration: 200}}
           }
        }
    }
}
