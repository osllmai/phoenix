import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import '../../../component_library/style' as Style
import '../../../component_library/button'

Item {
    id: control
    property string selectedMethod: "curl"

    Rectangle {
        id: instructionsBox
        anchors.fill: parent
        anchors.margins: 10
        radius: 12
        color: Style.Colors.boxHover
        border.color: "#444"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            RowLayout {
                id: rowMethodId
                spacing: 6

                Repeater {
                    model: ["curl", "python", "node", "httpie", "powershell", "go", "java", "csharp", "rust"]

                    delegate: MyButton {
                        id: delegateId
                        myText: modelData
                        bottonType: Style.RoleEnum.BottonType.Feature
                        iconType: Style.RoleEnum.IconType.FeatureBlue
                        isNeedAnimation: true
                        checkable: true
                        checked: control.selectedMethod === modelData
                        onClicked: control.selectedMethod = modelData
                    }
                }
            }

            ScrollView {
                id: scrollInstruction
                width: parent.width
                height:  parent.height - rowMethodId.height - 8
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    width: 6
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: 3
                        color: "#888"
                    }
                    background: Rectangle {
                        color: "#2e2e2e"
                    }
                }

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    height: 6
                    contentItem: Rectangle {
                        implicitHeight: 6
                        radius: 3
                        color: "#888"
                    }
                    background: Rectangle {
                        color: "#2e2e2e"
                    }
                }

                TextArea {
                    id: instructionTextBox
                    width: scrollInstruction.width
                    height: implicitHeight
                    readOnly: true
                    wrapMode: Text.NoWrap
                    color: "#e0e0e0"
                    font.family: "Courier New"
                    font.pointSize: 10
                    background: Rectangle {
                        color: "#1e1e1e"
                        radius: 8
                        border.color: "#444"
                        clip: true
                    }
                    padding: 10
                    cursorVisible: false
                    persistentSelection: false
                    clip: true

                    text: {
                        switch (selectedMethod) {
                        case "curl":
                            return `curl http://localhost:1234/v1/chat/completions \\
  -H "Content-Type: application/json" \\
  -d '{
    "model": "deepseek-r1-distill-qwen-7b",
    "messages": [
      { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
      { "role": "user", "content": "What day is it today?" }
    ],
    "temperature": 0.7,
    "stream": false
                            -H "Content-Type: application/json" \\
                            -d '{
                              "model": "deepseek-r1-distill-qwen-7b",
                              "messages": [
                                { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
                                { "role": "user", "content": "What day is it today?" }
                              ],
                              "temperature": 0.7,
                              "stream": false
}'`;

                        case "python":
                            return `import openai

response = openai.ChatCompletion.create(
    model="deepseek-r1-distill-qwen-7b",
    messages=[
        {"role": "system", "content": "Always answer in rhymes. Today is Thursday"},
        {"role": "user", "content": "What day is it today?"}
    ],
    temperature=0.7
)

print(response["choices"][0]["message"]["content"])`;

                        case "node":
                            return `const openai = require('openai');

const response = await openai.chat.completions.create({
    model: "deepseek-r1-distill-qwen-7b",
    messages: [
        { role: "system", content: "Always answer in rhymes. Today is Thursday" },
        { role: "user", content: "What day is it today?" }
    ],
    temperature: 0.7
});

console.log(response.choices[0].message.content);`;

                        case "httpie":
                            return `http POST http://localhost:1234/v1/chat/completions \\
  Content-Type:application/json \\
  model="deepseek-r1-distill-qwen-7b" \\
  messages:='[
    {"role": "system", "content": "Always answer in rhymes. Today is Thursday"},
    {"role": "user", "content": "What day is it today?"}
  ]' \\
  temperature:=0.7`;

                        case "powershell":
                            return `Invoke-RestMethod -Uri "http://localhost:1234/v1/chat/completions" -Method Post -Headers @{
    "Content-Type" = "application/json"
} -Body '{
    "model": "deepseek-r1-distill-qwen-7b",
    "messages": [
        { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
        { "role": "user", "content": "What day is it today?" }
    ],
    "temperature": 0.7
}'`;

                        case "go":
                            return `package main

import (
    "bytes"
    "fmt"
    "net/http"
)

func main() {
    jsonData := []byte(\`{
        "model": "deepseek-r1-distill-qwen-7b",
        "messages": [
            { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
            { "role": "user", "content": "What day is it today?" }
        ],
        "temperature": 0.7
    }\`)

    resp, err := http.Post("http://localhost:1234/v1/chat/completions", "application/json", bytes.NewBuffer(jsonData))
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()
    // handle response
}`;

                        case "java":
                            return `HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("http://localhost:1234/v1/chat/completions"))
    .header("Content-Type", "application/json")
    .POST(HttpRequest.BodyPublishers.ofString("""
        {
            "model": "deepseek-r1-distill-qwen-7b",
            "messages": [
                { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
                { "role": "user", "content": "What day is it today?" }
            ],
            "temperature": 0.7
        }
    """))
    .build();

HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
System.out.println(response.body());`;

                        case "csharp":
                            return `using var client = new HttpClient();
var content = new StringContent(@"{
    ""model"": ""deepseek-r1-distill-qwen-7b"",
    ""messages"": [
        { ""role"": ""system"", ""content"": ""Always answer in rhymes. Today is Thursday"" },
        { ""role"": ""user"", ""content"": ""What day is it today?"" }
    ],
    ""temperature"": 0.7
}", Encoding.UTF8, "application/json");

var response = await client.PostAsync("http://localhost:1234/v1/chat/completions", content);
var responseString = await response.Content.ReadAsStringAsync();
Console.WriteLine(responseString);`;

                        case "rust":
                            return `use reqwest::blocking::Client;
use serde_json::json;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::new();
    let res = client.post("http://localhost:1234/v1/chat/completions")
        .json(&json!({
            "model": "deepseek-r1-distill-qwen-7b",
            "messages": [
                { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
                { "role": "user", "content": "What day is it today?" }
            ],
            "temperature": 0.7
        }))
        .send()?;

    println!("{}", res.text()?);
    Ok(())
}`;

                        default:
                            return "";
                        }
                    }

                    onTextChanged: {
                        instructionTextBox.cursorPosition = instructionTextBox.length
                    }
                }
            }
        }
    }
}
