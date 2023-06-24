

export const loadContract = async (name) => {
    await fetch('/contracts/${}.json')
    const Artifact = await res.json()

    return {
        contract: Artifact
    }
}
