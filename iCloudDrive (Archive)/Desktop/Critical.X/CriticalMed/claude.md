1. First think through the problem, read the codebase for relevant files.
2. Before you make any major changes, check in with me and I will verify the plan.
3. Please every step of the way just give me a high level explanation of what changes you made
4. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
5. Maintain a documentation file that describes how the architecture of the app works inside and out.
6. Never speculate about code you have not opened. If the user references a specific file, you MUST read the file before answering. Make sure to investigate and read relevant files BEFORE answering questions about the codebase. Never make any claims about code before investigating unless you are certain of the correct answer - give grounded and hallucination-free answers.

## Medical Information Guidelines

1. **Never hallucinate medication data.** If you don't have exact dosing, mechanism, or contraindication information from the codebase, say so. Wrong medication information can kill patients.

2. **Verify all dosing against existing data models.** Cross-reference any medication changes with `ClinicalPharmacologyDataModel.swift` and `DripsDataModel.swift` to ensure consistency.

3. **Preserve safety boundaries.** Never modify or bypass `DosingSafetyChecker` validations without explicit discussion. Weight-based dose limits exist for patient safety.

4. **Pediatric vs adult dosing requires extra scrutiny.** Always confirm which population a dose applies to. Pediatric overdoses are a leading cause of medication errors.

5. **Include appropriate disclaimers.** This app provides clinical reference, not medical direction. Maintain existing disclaimer patterns in UI.

6. **Cite sources when adding new medical content.** Reference standard guidelines (ACLS, PALS, ATLS, UpToDate, package inserts) rather than generating medical facts.

7. **Contraindications and warnings are sacred.** Never remove or downplay adverse effects, black box warnings, or contraindications without explicit approval and source verification.

8. **When in doubt, be conservative.** For any ambiguous medical question, default to the safer interpretation or flag for review.
