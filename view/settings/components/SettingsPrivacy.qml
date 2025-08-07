import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style

Item {
    id: controlId
    clip: true

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 15
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
                <h1>Privacy Policy:</h1>

                <p><strong>Established & Effective Date:</strong> January 2024<br/>
                <strong>Update:</strong> August 04, 2025</p>

                <p>
                We at <a href='http://www.osllm.ai/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a> (the Company, we, or us) are committed to safeguarding the privacy of our customers. This Privacy Policy outlines how your <strong>Personal Information</strong> or <strong>Usage Information</strong> will be collected, used, shared, stored protected, or disclosed by our services (including <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>https://osllm.ai</a>).
                </p>

                <p>
                This Privacy Policy applies to the mobile applications or websites developed by us in relation to the services provided to you by the Company from time to time (Services).
                </p>

                <p>
                By using our Services, you agree to be bound by the terms of this Privacy Policy. If you do not accept the terms of this Privacy Policy, you are directed to discontinue accessing or using our applications in any way. We strongly recommend that you read this policy carefully before proceeding with any transaction on our platform.
                </p>

                <p>Please read these <strong>Terms of Use</strong> (Agreement) carefully before using the services offered by <strong>Durabuy American Import Export LLC</strong> (Company).</p>

                <p>By visiting the website <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>https://osllm.ai</a> and/or using the services in any manner, you agree that you have read, understood, and accept to be bound by these terms and conditions. If the terms of this Agreement are considered an offer, acceptance is expressly limited to such terms.</p>

                <p>If you do not unconditionally agree to all the terms and conditions of this Agreement, you have no right to use the website <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>https://osllm.ai</a>, applications, extensions, or services provided by <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>OS LLM AI</a>.</p>

                <p>Use of the Company's services is expressly conditioned upon your acceptance of these terms.</p>

                <ul>
                    <li><b>Country:</b> United States</li>
                    <li><b>Company:</b> Nemati AI (referred to as \"the Company\",\"We\", \"Us\", or \"Our\")</li>
                    <li><b>Address:</b> Milwaukee, WI 53209, United States</li>
                    <li><b>Phone:</b> +1 (971) 400-2132</li>
                    <li><strong>Website:</strong> <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>osllm.ai</a></li>
                    <li><strong>Email:</strong> <a href='mailto:support@osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>support@osllm.ai</a></li>
                </ul>

                <h2>Information We Collect:</h2>

                <p>We gather information about you for the following general purposes: to facilitate registration and manage your account, including providing access to and use of our Services; to communicate with you, including sharing information about us; to enable the publication of your reviews, forum posts, and other content; to respond to your questions and comments; to prevent potentially prohibited or illegal activities; and to enforce our Terms of Use.</p>

                <h3>Collecting and Using Your Personal Data:</h3>

                <p>When you visit or use our Services, we collect information about your computer or mobile device.</p>

                <p>Below are some details of the types of data we collect:</p>

                <h4>Technical Information:</h4>
                <p>We gather the IP address of the computer used to access our services, the mobile device ID (a unique identifier assigned by the manufacturer), and technical details about your computer or mobile device (such as device type, web browser, and operating system). This information helps us optimize the performance of our software on your devices and resolve any issues that may arise.</p>

                <h4>Content Characteristics:</h4>
                <p>When you use our services, we collect data from the inputs, file uploads, and feedback (Content) you provide. This information is essential for the proper functionality of features like <strong>History.</strong></p>

                <h4>Cookies:</h4>
                <p>When accessing our mobile application through a computer, we place Cookies on your device to identify it. Cookies are identifiers transferred to your computer or mobile device that allow us to recognize your browser or device and track how and when pages and features in our Services are accessed, as well as how many people visit them. You may adjust your browser or mobile device settings to prevent or limit the acceptance of cookies; however, this may restrict your ability to use some features of our Services.</p>

                <p>If you click on a link to a third-party website, that third party may also transmit cookies to you. Please note that this Privacy Policy does not govern the use of cookies by any third parties, and by continuing to use our Services, you acknowledge and accept this.</p>

                <h4>Personal Data:</h4>
                <p>While using our services, we may ask you to provide certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to:</p>

                <ul>
                    <li><strong>Email address</strong></li>
                    <li><strong>First name and last name</strong></li>
                    <li><strong>Usage and content generation data</strong></li>
                </ul>

                <h4>How We Use Your Information:</h4>

                <p>The Company may use Personal Data for the following purposes:</p>

                <ul>
                    <li><strong>To provide and maintain our Service</strong>: This includes monitoring the usage of our Service.</li>
                    <li><strong>To manage Your Account</strong>: This involves managing Your registration as a user of the Service. The Personal Data You provide grants You access to various functionalities of the Service available to You as a registered user.</li>
                    <li><strong>For the performance of a contract</strong>: This covers the development, compliance, and execution of the purchase contract for products, items, or services You have purchased, or any other contract with Us through the Service.</li>
                    <li><strong>To contact You</strong>: We may contact You via email or other equivalent forms of electronic communication, such as push notifications from a mobile application. These communications may include updates or information related to the functionalities, products, or contracted services, including security updates, when necessary or reasonable for their implementation.</li>
                    <li><strong>To provide You with news and offers</strong>: This includes providing You with news, special offers, and general information about other goods, services, and events we offer that are similar to those You have already purchased or inquired about, unless You have opted out of receiving such information.</li>
                    <li><strong>To manage Your requests</strong>: This involves attending to and managing any requests You make to Us.</li>
                    <li><strong>To deliver targeted advertising</strong>: We may use Your information to develop and display content and advertising, including working with third-party vendors, tailored to Your interests and/or location. This also includes measuring the effectiveness of such advertising.</li>
                    <li><strong>For other purposes</strong>: Your information may be used for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns, and evaluating and improving our Service, products, services, marketing strategies, and overall user experience.</li>
                </ul>

                <h2><strong>With whom we share your information?</strong></h2>

                <p>We neither rent nor sell your information in personally identifiable form to anyone to monetize through ads or leads.</p>

                <p>However, we do share your Personal Information with third parties as described below:</p>

                <h3>Third-party vendors:</h3>

                <p>We employ third-party vendors to provide services on our behalf for varied purposes, such as business analytics, customer service, marketing, distribution, payment processing, live chat, etc. We may authorize these vendors to collect information on our behalf to operate features of our application or deliver services tailored to your needs. We ensure that such information is used solely to perform their functions, and they are not permitted to share or use that information for any other purpose.ش</p>

                <h3>Companies within our corporate family:</h3>

                <p>We may be required to provide information about you to our parent company, subsidiary, or corporate affiliates. To the extent that our parent company, subsidiaries, or corporate affiliates have information about you, they will adhere to the best practices described in this Privacy Policy when using your information.</p>

                <h3>Business Partners:</h3>

                <p>We collaborate with Business Partners in offering our services to you. If you choose to access optional services provided by these partners, we may share information about you, including your personal information, with them. Please note that we do not control the privacy practices of these third-party Business Partners.</p>

                <h3>User Profiles and Submissions:</h3>

                <p>Certain user profile information, including but not limited to a user's name, location, and any video or image content uploaded to the Services, may be displayed to other users to facilitate interaction within the Services or address your requests for the Company's services. Any content you upload to your public user profile, along with any Personal Information or content voluntarily disclosed online in areas visible to others (e.g., discussion boards, messages, chat areas), becomes publicly available and may be collected and used by others. Your username may also be displayed to other users if and when you send messages, post comments, or upload images or videos through the Services. Other users may contact you through messages and comments. Please note that we do not control the policies and practices of third-party sites or services interacting with our Services.</p>

                <h3>Affiliated Websites:</h3>

                <p>If you were referred to us from another website, we might need to share registration information, including but not limited to your name, email address, and phone numbers. In such cases, we encourage you to review the Privacy Policy of the referring website. We are not responsible for their handling of your information.</p>

                <h3>Business Transfers:</h3>

                <p>If we choose to buy or sell assets, customer information is typically one of the business assets transferred. Similarly, if we (or our assets) are acquired, or if we go out of business, enter bankruptcy, or undergo another change of control, Personal Information may be one of the assets transferred to or acquired by a third party.</p>

                <h3>Government Bodies:</h3>

                <p>We may disclose your Personal Information and Usage Information when required by law, such as responding to a subpoena, court order, government demand, or other legal requirements to protect our interests. In such cases, we will contact you via email. Communications sent to your provided email address will be deemed as having been communicated to you.</p>

                <h2>Retention of Your Personal Data:</h2>

                <p>The Company will retain Your Personal Data only for as long as necessary to fulfill the purposes outlined in this Privacy Policy. We will retain and use Your Personal Data to the extent required to comply with our legal obligations (for instance, if applicable laws mandate data retention), resolve disputes, and enforce our legal agreements and policies.</p>

                <h2>How Do We Protect Your Information:</h2>

                <p>We want you to feel completely confident that your information is safe and secure with us. We adhere to generally accepted standards to safeguard the Personal Information and Usage Information submitted to us. While no services can guarantee foolproof security, we have implemented appropriate administrative, technical, and security procedures to keep your information intact, secure, and confidential. Your information is accessed only for necessary purposes by authorized employees, agents, or third-party vendors. To ensure its security, we use firewalls, encryption technologies, and intrusion detection systems to protect your information from unauthorized use.</p>

                <h2>What Happens When You Use Our Services from Outside Your Region?</h2>

                <p>If you are accessing our application from outside the United States, please note that your information may be transferred, stored, or processed in the United States, where our servers and central databases are located. Regardless of your location, we adhere to best practices to protect your information. By using our Services, you acknowledge that we operate under the United States Privacy and Data Protection Laws, which may differ significantly from those of your country.</p>

                <p>The Company will take all reasonably necessary steps to ensure that your data is treated securely and in compliance with this Privacy Policy. No transfer of your Personal Data will occur to an organization or country unless adequate controls, including data security measures, are in place to protect your personal information.</p>

                <h2>Email Marketing:</h2>

                <p>We may use your personal data to send newsletters, marketing or promotional materials, and other information that may interest you.</p>

                <p>You can opt out of receiving any or all of these communications by:</p>

                <ul>
                    <li>Following the unsubscribe link or instructions provided in any email we send, or</li>
                    <li>Contacting us directly.</li>
                </ul>

                <p>For more details, you may review <a href='https://aws.amazon.com/cn/privacy/' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>Amazon SES's Privacy Policy</a>.</p>

                <h2>Payments:</h2>

                <p>We may use third-party services, such as <strong>Stripe</strong>, for payment processing.</p>

                <p>We do not store or collect your payment card details. This information is provided directly to our third-party payment processors, whose use of your personal information is governed by their Privacy Policy. These payment processors comply with <strong>PCI-DSS</strong> standards, which are managed by the <strong>PCI Security Standards Council</strong>—a collaborative effort of brands like Visa, Mastercard, American Express, and Discover. <strong>PCI-DSS requirements</strong> ensure the secure handling of payment information.</p>

                <p>You can review Stripe's Privacy Policy <a href='https://stripe.com/privacy' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>here</a>.</p>

                <h2>GDPR Privacy:</h2>

                <h3>Legal Basis for Processing Personal Data under GDPR:</h3>

                <p>We may process Personal Data under the following conditions:</p>

                <ul>
                    <li><strong>Consent</strong>: You have given Your consent for processing Personal Data for one or more specific purposes.</li>
                    <li><strong>Performance of a contract</strong>: Provision of Personal Data is necessary for the performance of an agreement with You and/or for any pre-contractual obligations thereof.</li>
                    <li><strong>Legal obligations</strong>: Processing Personal Data is necessary for compliance with a legal obligation to which the Company is subject.</li>
                    <li><strong>Vital interests</strong>: Processing Personal Data is necessary in order to protect Your vital interests or those of another natural person.</li>
                    <li><strong>Public interests</strong>: Processing Personal Data is related to a task that is carried out in the public interest or in the exercise of official authority vested in the Company.</li>
                    <li><strong>Legitimate interests</strong>: Processing Personal Data is necessary for the purposes of the legitimate interests pursued by the Company.</li>
                </ul>

                <p>In any case, the Company will gladly help to clarify the specific legal basis that applies to the processing, and in particular whether the provision of Personal Data is a statutory or contractual requirement, or a requirement necessary to enter into a contract.</p>

                <h3>Your Rights under the GDPR:</h3>

                <p>The Company undertakes to respect the confidentiality of Your Personal Data and to guarantee that You can exercise Your rights.</p>

                <p>You have the right under this Privacy Policy, and by law if You are within the EU, to:</p>

                <ul>
                    <li><strong>Request access to Your Personal Data</strong>: The right to access, update, or delete the information We have on You. Whenever possible, You can access, update, or request deletion of Your Personal Data directly within Your account settings section. If You are unable to perform these actions yourself, please contact Us to assist You. This also enables You to receive a copy of the Personal Data We hold about You.</li>
                    <li><strong>Request correction of the Personal Data that We hold about You</strong>: You have the right to have any incomplete or inaccurate information We hold about You corrected.</li>
                    <li><strong>Object to processing of Your Personal Data</strong>: This right exists where We are relying on a legitimate interest as the legal basis for Our processing and there is something about Your particular situation that makes You want to object to Our processing of Your Personal Data on this ground. You also have the right to object where We are processing Your Personal Data for direct marketing purposes.</li>
                    <li><strong>Request erasure of Your Personal Data</strong>: You have the right to ask Us to delete or remove Personal Data when there is no good reason for Us to continue processing it.</li>
                    <li><strong>Request the transfer of Your Personal Data</strong>: We will provide to You, or to a third-party You have chosen, Your Personal Data in a structured, commonly used, machine-readable format. Please note that this right only applies to automated information which You initially provided consent for Us to use or where We used the information to perform a contract with You.</li>
                    <li><strong>Withdraw Your consent</strong>: You have the right to withdraw Your consent to the use of Your Personal Data. If You withdraw Your consent, We may not be able to provide You with access to certain specific functionalities of the Service.</li>
                </ul>

                <h2>CCPA Privacy:</h2>

                <p>This privacy notice section for California residents supplements the information contained in Our Privacy Policy and applies solely to all visitors, users, and others who reside in the State of California.</p>

                <h3>Sources of Personal Information:</h3>

                <p>We obtain the categories of personal information listed above from the following categories of sources:</p>

                <ul>
                    <li><strong>Directly from You.</strong> For example, from the forms You complete on our Service, preferences You express or provide through our Service, or from Your purchases on our Service.</li>
                    <li><strong>Indirectly from You.</strong> For example, from observing Your activity on our Service.</li>
                    <li><strong>Automatically from You.</strong> For example, through cookies We or our Service Providers set on Your Device as You navigate through our Service.</li>
                    <li><strong>From Service Providers.</strong> For example, third-party vendors to monitor and analyze the use of our Service, third-party vendors to provide advertising on our Service, third-party vendors to deliver targeted advertising to You, third-party vendors for payment processing, or other third-party vendors that We use to provide the Service to You.</li>
                </ul>

                <h3>Use of Personal Information for Business Purposes or Commercial Purposes:</h3>

                <p>We may use or disclose personal information We collect for business purposes or commercial purposes (as defined under the CCPA), which may include the following examples:</p>

                <ul>
                    <li>To operate our Service and provide You with our Service.</li>
                    <li>To provide You with support and respond to Your inquiries, including investigating and addressing Your concerns and monitoring and improving our Service.</li>
                    <li>To fulfill or meet the reason You provided the information. For example, if You share Your contact information to ask a question about our Service, We will use that personal information to respond to Your inquiry. If You provide Your personal information to purchase a product or service, We will use that information to process Your payment and facilitate delivery.</li>
                    <li>To respond to law enforcement requests and as required by applicable law, court order, or governmental regulations.</li>
                    <li>As described to You when collecting Your personal information or as otherwise set forth in the CCPA. For internal administrative and auditing purposes.</li>
                    <li>To detect security incidents and protect against malicious, deceptive, fraudulent, or illegal activity, including, when necessary, prosecuting those responsible for such activities.</li>
                </ul>

                <p>Please note that the examples provided above are illustrative and not intended to be exhaustive. For more details on how we use this information, please refer to the Use of Your Personal Data section. If We decide to collect additional categories of personal information or use the personal information We collected for materially different, unrelated, or incompatible purposes, We will update this Privacy Policy.</p>

                <h2>Personal Information of Minors:</h2>

                <p>If you have reason to believe that a child under the age of 13 (or 16) has provided us with personal information, please contact us with sufficient detail to enable us to delete that information.</p>

                <h2>Your Rights under the CCPA:</h2>

                <p>The CCPA provides California residents with specific rights regarding their personal information.</p>

                <p>If you are a resident of California, you have the following rights:</p>

                <h3>The Right to Notice:</h3>

                <p>You have the right to be notified of which categories of Personal Data are being collected and the purposes for which the Personal Data is being used.</p>

                <h3>The Right to Request:</h3>

                <p>Under the CCPA, you have the right to request that we disclose information to you about our collection, use, sale, disclosure for business purposes, and sharing of personal information.</p>

                <p>Once we receive and confirm your request, we will disclose to you:</p>

                <ul>
                    <li>The categories of personal information we collected about you.</li>
                    <li>The categories of sources for the personal information we collected about you.</li>
                    <li>Our business or commercial purpose for collecting or selling that personal information.</li>
                    <li>The categories of third parties with whom we share that personal information.</li>
                    <li>The specific pieces of personal information we collected about you.</li>
                </ul>

                <p>If we sold your personal information or disclosed your personal information for a business purpose, we will disclose to you:</p>

                <ul>
                    <li>The categories of personal information sold.</li>
                    <li>The categories of personal information disclosed.</li>
                </ul>

                <h3>The Right to Say No to the Sale of Personal Data (Opt-Out):</h3>

                <p>You have the right to direct us not to sell your personal information. To submit an opt-out request, please contact us.</p>

                <h3>The Right to Delete Personal Data:</h3>

                <p>You have the right to request the deletion of your Personal Data, subject to certain exceptions. Once we receive and confirm your request, we will delete (and direct our Service Providers to delete) your personal information from our records, unless an exception applies.</p>

                <p>We may deny your deletion request if retaining the information is necessary for us or our Service Providers to:</p>

                <ul>
                    <li>Complete the transaction for which we collected the personal information, provide a good or service that you requested, take actions reasonably anticipated within the context of our ongoing business relationship with you, or otherwise perform our contract with you.</li>
                    <li>Detect security incidents, protect against malicious, deceptive, fraudulent, or illegal activity, or prosecute those responsible for such activities.</li>
                    <li>Debug products to identify and repair errors that impair existing intended functionality.</li>
                    <li>Exercise free speech, ensure the right of another consumer to exercise their free speech rights, or exercise another right provided for by law.</li>
                    <li>Comply with the California Electronic Communications Privacy Act (Cal. Penal Code § 1546 et seq.).</li>
                    <li>Engage in public or peer-reviewed scientific, historical, or statistical research in the public interest that adheres to all other applicable ethics and privacy laws, when the information's deletion may likely render impossible or seriously impair the research's achievement, if you previously provided informed consent.</li>
                    <li>Enable solely internal uses that are reasonably aligned with consumer expectations based on your relationship with us.</li>
                    <li>Comply with a legal obligation.</li>
                    <li>Make other internal and lawful uses of that information that are compatible with the context in which you provided it.</li>
                </ul>

                <h3>The Right Not to Be Discriminated Against:</h3>

                <p>You have the right not to be discriminated against for exercising any of your consumer rights, including by:</p>

                <ul>
                    <li>Denying goods or services to you.</li>
                    <li>Charging different prices or rates for goods or services, including the use of discounts or other benefits or imposing penalties.</li>
                    <li>Providing a different level or quality of goods or services to you.</li>
                    <li>Suggesting that you will receive a different price or rate for goods or services or a different level or quality of goods or services.</li>
                </ul>

                <h2>Changes to this Privacy Policy:</h2>

                <p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.</p>

                <p>We will also inform you via email and/or a prominent notice on our Service prior to the changes becoming effective, and we will update the Last updated date at the top of this Privacy Policy.</p>

                <p>You are encouraged to review this Privacy Policy periodically for any changes. Updates to this Privacy Policy become effective as soon as they are posted on this page.</p>

                <h2>Contact Us:</h2>

                <p>If you have any questions about this Privacy Policy, You can contact us at support: <a href='mailto:support@osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>support@osllm.ai</a></p>
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
